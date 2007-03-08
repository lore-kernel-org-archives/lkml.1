Return-Path: <linux-kernel-owner+w=401wt.eu-S1751458AbXCHLsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbXCHLsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 06:48:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbXCHLsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 06:48:30 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:42034 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751458AbXCHLsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 06:48:30 -0500
Date: Thu, 8 Mar 2007 12:47:53 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Vivek Goyal <vgoyal@in.ibm.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Reloc Kernel List <fastboot@lists.osdl.org>, ebiederm@xmission.com,
       akpm@linux-foundation.org, ak@suse.de, hpa@zytor.com,
       magnus.damm@gmail.com, lwang@redhat.com, dzickus@redhat.com,
       rjw@sisk.pl
Subject: Re: [PATCH 15/20] Move swsusp __pa() dependent code to arch portion
Message-ID: <20070308114753.GH5953@elf.ucw.cz>
References: <20070307065703.GA23412@in.ibm.com> <20070307071850.GP23412@in.ibm.com> <20070307224740.GF5956@elf.ucw.cz> <20070308053459.GI6000@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070308053459.GI6000@in.ibm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > +int pfn_is_nosave(unsigned long pfn)
> > > +{
> > > +	unsigned long nosave_begin_pfn = __pa_symbol(&__nosave_begin) >> PAGE_SHIFT;
> > > +	unsigned long nosave_end_pfn = PAGE_ALIGN(__pa_symbol(&__nosave_end)) >> PAGE_SHIFT;
> > > +	return (pfn >= nosave_begin_pfn) && (pfn < nosave_end_pfn);
> > > +}
> > 
> > ...in asm-generic/suspend.h (or something) and then just include it?
> > 									Pavel
> 
> As code is not exactly same, we can't put it in asm-generic/suspend.h.

Ok... ACK on the original patch, then.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
