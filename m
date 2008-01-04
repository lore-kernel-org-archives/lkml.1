Return-Path: <linux-kernel-owner+w=401wt.eu-S1753832AbYADOPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbYADOPB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 09:15:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbYADOOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 09:14:53 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:43576 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbYADOOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 09:14:52 -0500
Date: Fri, 4 Jan 2008 14:14:43 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: return -EPERM when preventing read of /proc/*/maps
Message-ID: <20080104141443.GB27894@ZenIV.linux.org.uk>
References: <20080104135731.2908.90012.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080104135731.2908.90012.stgit@localhost.localdomain>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2008 at 02:57:31PM +0100, Guillaume Chazarain wrote:
> Return an error instead of successfully reading an empty file.

vma_stop() doesn't need changes either...
