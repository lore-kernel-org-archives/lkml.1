Return-Path: <linux-kernel-owner+w=401wt.eu-S1761590AbXGYUkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761590AbXGYUkd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 16:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755698AbXGYUk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 16:40:26 -0400
Received: from [212.12.190.42] ([212.12.190.42]:33083 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752599AbXGYUkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 16:40:25 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] ACPI patches for 2.6.23-rc1
Date: Wed, 25 Jul 2007 23:40:46 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707252340.46505.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Wed, 25 Jul 2007, Len Brown wrote:
> > git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git
> > release
> >
> > Fixes regressions -- a build failure, an oops, some dmesg spam.
> > Also fixes some D-state issues and adds ACPI module auto-loading.
> > Yes, I'd hoped to get the last two in before rc1.
> > I'm hopeful that a couple-days into rc2 is sufficiently early for them.
>
> I hate pulling this, but I did. However, what I hate even more after
> having done so is that ACPI now seems to select CPU hotplug. Why?
>
> That is just *broken*. Sure, if you select STR or hibernation, we need CPU
> hotplug,

You are kidding, right?  CPU hotplug is broken big time; it kills a machine 
like virus-scanner.  I always turn it of as a rule.  And now you want 
STR/STD to be dependent on it?  Even on UP?  Why?


Thanks!

--
Al

