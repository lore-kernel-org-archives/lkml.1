Return-Path: <linux-kernel-owner+w=401wt.eu-S1751165AbXCUJtH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751165AbXCUJtH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 05:49:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbXCUJtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 05:49:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:57399 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbXCUJtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 05:49:05 -0400
From: Andi Kleen <ak@suse.de>
To: tglx@linutronix.de
Subject: Re: BUG lapic: Can't boot on battery (2.6.21-rc{1,2,3,4})
Date: Wed, 21 Mar 2007 10:46:19 +0100
User-Agent: KMail/1.9.1
Cc: Grzegorz Chwesewicz <grzegorz.chwesewicz@chilan.com>,
       Stefan Prechtel <stefan.prechtel@googlemail.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu,
       Len Brown <lenb@kernel.org>, john stultz <johnstul@us.ibm.com>
References: <b93822910703191010s1ac9d5d7jf9f761ecb933cc77@mail.gmail.com> <20070320164604.M60273@chilan.com> <1174469047.10840.7.camel@localhost.localdomain>
In-Reply-To: <1174469047.10840.7.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703211046.20724.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 March 2007 10:24, Thomas Gleixner wrote:
> On Tue, 2007-03-20 at 17:47 +0100, Grzegorz Chwesewicz wrote:
> > I have HP nx6325. I've tried to use WARN_ON_ONCE patch, but I don't see
> > nothing special in dmesg. Just in case I'm posting my
> > dmesg_2.6.20_WARN_ON_ONCE_on_battery log on
> > http://bugzilla.kernel.org/show_bug.cgi?id=8235 .
> >
> > Below I post output of my /proc interrupts (10 sec. delay between reads).
> >
> > Other interesting thing on 2.6-git is that when I press a key on keyboard
> > it doesn't repeat (on battery), but it repeats on 2.6-git on ac.
>
> Sigh. The periodic PIT interrupt pampers over the problem in <2.6.21-rc.
> It prevents the BIOS to switch the CPU in lower power states.

I think I ran into the same problem with my initial noidletick patch.
I don't have that test machine anymore though.

Normally the "use PIT when AMD && Cstate >= 2" check should
have caught that though. Why did it here?

-Andi

