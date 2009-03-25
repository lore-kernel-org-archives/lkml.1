Return-Path: <linux-kernel-owner+w=401wt.eu-S1756065AbZCYBa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbZCYBa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 21:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757606AbZCYB3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 21:29:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:30346 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757786AbZCYB3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 21:29:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,416,1233561600"; 
   d="scan'208";a="397287937"
Subject: Re: sd-async-shutdown.patch [was: 2.6.30 -mm merge plans]
From: Shaohua Li <shaohua.li@intel.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "arjan@infradead.org" <arjan@infradead.org>,
       "James.Bottomley@HansenPartnership.com" 
	<James.Bottomley@HansenPartnership.com>
In-Reply-To: <49C9885F.2090604@gmail.com>
References: <20090323224615.cd29edfd.akpm@linux-foundation.org>
	 <49C9885F.2090604@gmail.com>
Content-Type: text/plain
Date: Wed, 25 Mar 2009 09:29:37 +0800
Message-Id: <1237944577.15493.0.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-25 at 09:26 +0800, Robert Hancock wrote:
> Andrew Morton wrote:
> >     sd-async-shutdown.patch
> > 
> >  Merge
> 
> This one seems questionable to me. Is this going to allow the machine to 
> power off before the disk shutdown is complete? That's definitely 
> something we don't want (for cache flushing and head unload reasons).
There is another patch which will sync all device shutdown, so to
guarantee device shutdown completed.

Thanks,
Shaohua

