Return-Path: <linux-kernel-owner+w=401wt.eu-S1753656AbXGZEIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbXGZEIP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 00:08:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750728AbXGZEIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 00:08:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:60471 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbXGZEIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 00:08:04 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Al Boldi <a1426z@gawab.com>
Subject: Re: [GIT PATCH] ACPI patches for 2.6.23-rc1
Date: Thu, 26 Jul 2007 00:07:59 -0400
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <200707252340.46505.a1426z@gawab.com>
In-Reply-To: <200707252340.46505.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707260007.59203.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 July 2007 16:40, Al Boldi wrote:
> Linus Torvalds wrote:
> > On Wed, 25 Jul 2007, Len Brown wrote:
> > > git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git
> > > release
> > >
> > > Fixes regressions -- a build failure, an oops, some dmesg spam.
> > > Also fixes some D-state issues and adds ACPI module auto-loading.
> > > Yes, I'd hoped to get the last two in before rc1.
> > > I'm hopeful that a couple-days into rc2 is sufficiently early for them.
> >
> > I hate pulling this, but I did. However, what I hate even more after
> > having done so is that ACPI now seems to select CPU hotplug. Why?
> >
> > That is just *broken*. Sure, if you select STR or hibernation, we need CPU
> > hotplug,
> 
> You are kidding, right?  CPU hotplug is broken big time; it kills a machine 
> like virus-scanner.  I always turn it of as a rule.  And now you want 
> STR/STD to be dependent on it?  Even on UP?  Why?

CPU_HOTPLUG is needed to take the non-boot processors off-line before the suspend,
and to bring them on-line upon the resume.  If you have specific problems
with bringing logical processors offline and online, then please speak up
because many are depending on this functionality working.

SMP system sleep support has always depended on CPU_HOTPLUG, per above.

No, uniprocessor system sleep does not depend on CPU_HOTPLUG.

-Len
