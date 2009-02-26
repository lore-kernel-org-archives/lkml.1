Return-Path: <linux-kernel-owner+w=401wt.eu-S1759901AbZBZWHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759901AbZBZWHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 17:07:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755647AbZBZWHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 17:07:32 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:50026 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755518AbZBZWHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 17:07:31 -0500
Date: Thu, 26 Feb 2009 16:07:26 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH -mm] namespaces: get_sb_ns does not require CONFIG_BLOCK
Message-ID: <20090226220726.GA25520@us.ibm.com>
References: <20090226220525.GA25317@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090226220525.GA25317@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Serge E. Hallyn (serue@us.ibm.com):
> So move it outside of the CONFIG_BLOCK ifdef in fs/super.c.

Sorry, Andrew.  I meant to add the following to the description:

Without this patch, compilation breaks on fs/proc/proc_net.c
if CONFIG_BLOCK=n.

thanks,
-serge
