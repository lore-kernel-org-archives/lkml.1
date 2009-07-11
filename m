Return-Path: <linux-kernel-owner+w=401wt.eu-S1752904AbZGLLg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbZGLLg1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 07:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbZGLLgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 07:36:20 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42144 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbZGLLgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 07:36:19 -0400
Date: Sun, 12 Jul 2009 00:02:11 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Len Brown <lenb@kernel.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, sfi-devel@simplefirmware.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 2.6.32] Simple Firmware Interface (SFI): initial
	support
Message-ID: <20090711220211.GA1670@ucw.cz>
References: <1245741246-6503-1-git-send-email-lenb@kernel.org> <20090623183153.GB12814@srcf.ucam.org> <alpine.LFD.2.00.0906231438190.23079@localhost.localdomain> <20090622194303.GC2284@ucw.cz> <alpine.LFD.2.00.0906241645250.20716@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0906241645250.20716@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-06-24 17:13:18, Len Brown wrote:
> On Mon, 22 Jun 2009, Pavel Machek wrote:
> 
> > On Tue 2009-06-23 14:41:28, Len Brown wrote:
> 
> > > Please let me know if your questions are not thoroughly answered here:
> > > http://simplefirmware.org/faq
> > 
> > It really tells us nothing. I don't think flash got so expensive that
> > this is justified. ACPI can already do the job, right? and operating
> > systems already have to support ACPI. So what are the reasons to
> > reinvent the wheel?
> 
> The price of flash, and the amount consumed, is not relevent
> to the decision whether a platform should support SFI or ACPI.
> 
> The Moorestown platform doesn't use ACPI because its chip-set
> fundamentally does not support it.  Not only is the required
> register set missing, *all* IO accesses are missing, and there is
> no SMM support present to emuate it.
> 
> Yes, the ACPI specification could have been edited to replace
> every "must" with "could", "shall" with "may", and "required" with 
> "optional" resulting in "ACPI compliance" for your toaster.
> But doing so would have been a dis-service to the
> platforms supporting ACPI, and would have made the
> already hard job of supporting ACPI from the OS significantly harder.

Well, you should have just selected subset of ACPI, documenting that
and implementing that. You would not have 'acpi compliant' logo, and
windows XP would not boot on that, but at least you would not have
created one more bios standard for people to support.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
