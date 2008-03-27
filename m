Return-Path: <linux-kernel-owner+w=401wt.eu-S1759255AbYC0Jam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759255AbYC0Jam (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 05:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755659AbYC0JaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 05:30:21 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:53459 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbYC0JaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 05:30:19 -0400
Date: Thu, 27 Mar 2008 09:42:31 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>,
       kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: iommu breaks usb after resume
Message-ID: <20080327084231.GC25876@elf.ucw.cz>
References: <20080320111429.GA14764@elf.ucw.cz> <20080321135418.GB2346@one.firstfloor.org> <20080326102151.GB18965@elf.ucw.cz> <20080326130052.GF2170@one.firstfloor.org> <20080326225407.GA9378@elf.ucw.cz> <20080326230017.GA21017@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080326230017.GA21017@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-03-27 00:00:17, Ingo Molnar wrote:
> 
> * Pavel Machek <pavel@ucw.cz> wrote:
> 
> > @@ -733,8 +735,8 @@ static struct pci_driver agp_amd64_pci_d
> >  	.probe		= agp_amd64_probe,
> >  	.remove		= agp_amd64_remove,
> >  #ifdef CONFIG_PM
> > -	.suspend	= agp_amd64_suspend,
> > -	.resume		= agp_amd64_resume,
> > +	.suspend_late	= agp_amd64_suspend,
> > +	.resume_early	= agp_amd64_resume,
> >  #endif
> 
> ah, makes sense. I've queued up your fix in x86.git (sans the debug 
> printks), please send your signoff once you can verify that it solves 
> the hibernation hang on your box and we'll push it into 2.6.25.

You have my signed-off from previous email, but...

it does not solve a problem here -- see the mail to andi. It may still
be good idea to take it (but I do not think it should go to 2.6.25),
but may machine still does not work.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
