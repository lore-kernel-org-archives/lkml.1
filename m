Return-Path: <linux-kernel-owner+w=401wt.eu-S2992527AbXCGW5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992527AbXCGW5G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 17:57:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965702AbXCGW5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 17:57:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:35729 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965715AbXCGW5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 17:57:03 -0500
Date: Wed, 7 Mar 2007 23:57:02 +0100
From: Bernhard Walle <bwalle@suse.de>
To: fastboot@lists.osdl.org,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [Fastboot] [PATCH 12/20] x86_64: 64bit ACPI wakeup trampoline
Message-ID: <20070307225702.GA1040@strauss.suse.de>
Mail-Followup-To: fastboot@lists.osdl.org,
	linux kernel mailing list <linux-kernel@vger.kernel.org>
References: <20070307065703.GA23412@in.ibm.com> <20070307071458.GM23412@in.ibm.com> <20070307224508.GE5956@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307224508.GE5956@elf.ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Machek <pavel@ucw.cz> [2007-03-07 23:45]:
> 
> > +	if ((&wakeup_end - &wakeup_start) > (PAGE_SIZE*2))
> >  		printk(KERN_CRIT
> > -		       "ACPI: Wakeup code way too big, will crash on attempt to suspend\n");
> > +		       "ACPI: Wakeup code way too big, will crash on attempt"
> > +		       " to suspend\n");
> 
> Hmm, if you split it like
> 		printk(KERN_CRIT "ACPI: Wakeup code way too big, will crash"
> 			"on attempt to suspend\n");
> 
> ...you'll still keep 80-column rule while keeping it readable.

But I guess with a space after "crash" or before "on" :)


Regards,
Bernhard
