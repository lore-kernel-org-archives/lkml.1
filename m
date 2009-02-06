Return-Path: <linux-kernel-owner+w=401wt.eu-S1758175AbZBFC3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175AbZBFC3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 21:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbZBFC3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 21:29:11 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:46552 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbZBFC3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 21:29:09 -0500
Subject: Re: [PATCH 0/6] integrity
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       "<David Safford" <safford@watson.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>
In-Reply-To: <alpine.LRH.1.10.0902061059510.13961@tundra.namei.org>
References: <cover.1233262162.git.zohar@linux.vnet.ibm.com>
	 <alpine.LRH.1.10.0902061059510.13961@tundra.namei.org>
Content-Type: text/plain
Date: Thu, 05 Feb 2009 21:29:01 -0500
Message-Id: <1233887341.3135.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-06 at 11:00 +1100, James Morris wrote:
> I seem to be getting a bunch of these in my logs with IMA running:
> 
> auditd[1746]: dispatch err (Bad address) event lost
> 

auditd needs to reflect the integrity definitions defined in
include/linux/audit.h.  ausearch-parse needs to be updated as well. For
which version of auditd should I post a patch? I have one for
audit-1.7.9.

Thanks!

Mimi


