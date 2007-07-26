Return-Path: <linux-kernel-owner+w=401wt.eu-S1759530AbXGZFIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759530AbXGZFIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 01:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbXGZFIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 01:08:15 -0400
Received: from [212.12.190.27] ([212.12.190.27]:32851 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751495AbXGZFIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 01:08:14 -0400
From: Al Boldi <a1426z@gawab.com>
To: david@lang.hm, Len Brown <lenb@kernel.org>
Subject: Re: [GIT PATCH] ACPI patches for 2.6.23-rc1
Date: Thu, 26 Jul 2007 08:07:52 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org
References: <200707252340.46505.a1426z@gawab.com> <200707260007.59203.lenb@kernel.org> <Pine.LNX.4.64.0707252113020.21378@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0707252113020.21378@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707260807.52704.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> On Thu, 26 Jul 2007, Len Brown wrote:
> > On Wednesday 25 July 2007 16:40, Al Boldi wrote:
> >> Linus Torvalds wrote:
> >>> On Wed, 25 Jul 2007, Len Brown wrote:
> >>>> git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git
> >>>> release
> >>>>
> >>>> Fixes regressions -- a build failure, an oops, some dmesg spam.
> >>>> Also fixes some D-state issues and adds ACPI module auto-loading.
> >>>> Yes, I'd hoped to get the last two in before rc1.
> >>>> I'm hopeful that a couple-days into rc2 is sufficiently early for
> >>>> them.
> >>>
> >>> I hate pulling this, but I did. However, what I hate even more after
> >>> having done so is that ACPI now seems to select CPU hotplug. Why?
> >>>
> >>> That is just *broken*. Sure, if you select STR or hibernation, we need
> >>> CPU hotplug,
> >>
> >> You are kidding, right?  CPU hotplug is broken big time; it kills a
> >> machine like virus-scanner.  I always turn it of as a rule.  And now
> >> you want STR/STD to be dependent on it?  Even on UP?  Why?
> >
> > CPU_HOTPLUG is needed to take the non-boot processors off-line before
> > the suspend, and to bring them on-line upon the resume.  If you have
> > specific problems with bringing logical processors offline and online,
> > then please speak up because many are depending on this functionality
> > working.
>
> nobody is arguing that CPU_HOTPLUG should not be a requirement for
> suspend, what we are questioning is why simply enabling ACPI should
> require CPU_HOTPLUG.
>
> not everyone who configures ACPI wants to use suspend (of any flavor)

Actually, I would go one step further and just rip out hotplug from the 
kernel proper, and let userland handle it.  Really, just like devfs, hotplug 
has no place in the kernel.


Thanks!

--
Al

