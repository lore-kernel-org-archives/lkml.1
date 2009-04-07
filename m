Return-Path: <linux-kernel-owner+w=401wt.eu-S1760726AbZDGSW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760726AbZDGSW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 14:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759328AbZDGSWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 14:22:07 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:13713 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757580AbZDGSWD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 14:22:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aTXhWl1/Ms+t2rN0N5wU47fYMX0idgnoaoPYLlLBJZAn8S4ah0RQns7cnd+23wdHfg
         jPIlnRDhQWP53lQ3HTUETwB1++79dFpgxXp5mVTfgptupPDPGgST1ju2llooeIsFhxBJ
         RaqxrTz0z+wEYQucYg7BOC/8Ti//sU7397ljA=
MIME-Version: 1.0
In-Reply-To: <49DB8909.3000905@s5r6.in-berlin.de>
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera>
	 <alpine.LFD.2.00.0904061443000.7443@localhost.localdomain>
	 <49DB7C77.1000702@s5r6.in-berlin.de>
	 <9b1675090904070944m798ed608i1d9194ebd1ed3961@mail.gmail.com>
	 <49DB8909.3000905@s5r6.in-berlin.de>
Date: Tue, 7 Apr 2009 12:22:01 -0600
Message-ID: <9b1675090904071122k6a53295fwfffc336011edee8e@mail.gmail.com>
Subject: Re: 2.6.29 on MacBook 2,1 fails to reboot (was Re: 2.6.29-git13: 
	Reported regressions from 2.6.28)
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 7, 2009 at 11:10 AM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> Trenton D. Adams wrote:
> Interdependencies between ALSA modules have changed.  The Gentoo init
> scripts attempted to unload them in an order which deadlocked modprobe
> due to dependencies.  The fix for Gentoo is to just not unload the
> modules on system shutdown.  My Gentoo/amd64 Mac mini was affected by
> this too; fixed by userland update.
>

While that is interesting, I am not seeing that problem on my Gentoo
box (the macbook), which is completely up-to-date.  2.6.28 works, and
2.6.29 doesn't.  Same init scripts, different kernels.

And sure, I could put a comment on the rmmod, in the init script, but
IMO that would be a hack around a _bug_.  Which is fine for me.  But,
is it worth leaving the issue in the kernel?
