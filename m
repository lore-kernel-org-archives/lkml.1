Return-Path: <linux-kernel-owner+w=401wt.eu-S1753191AbXJURx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbXJURx4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 13:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751639AbXJURxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 13:53:48 -0400
Received: from hoboe1bl1.telenet-ops.be ([195.130.137.72]:48213 "EHLO
	hoboe1bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbXJURxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 13:53:47 -0400
Date: Sun, 21 Oct 2007 19:53:43 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       =?UTF-8?Q?Christian_Bj=C3=B8levik?= <nafallo@magicalforest.se>,
       Deepak Saxena <dsaxena@mvista.com>, Armin Kuster <akuster@mvista.com>,
       Adrian Bunk <bunk@kernel.org>
Subject: Re: kbuild: disable depmod in cross-compile kernel build
In-Reply-To: <200710192259.l9JMxENl018922@hera.kernel.org>
Message-ID: <Pine.LNX.4.64.0710211948450.6155@anakin>
References: <200710192259.l9JMxENl018922@hera.kernel.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463808512-1964029385-1192988968=:6155"
Content-ID: <Pine.LNX.4.64.0710211950240.6155@anakin>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463808512-1964029385-1192988968=:6155
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.64.0710211950241.6155@anakin>

On Fri, 19 Oct 2007, Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=50a8ec31c3a00594ceb7c5f1dcf2ecdaf6a5b847
> Commit:     50a8ec31c3a00594ceb7c5f1dcf2ecdaf6a5b847
> Parent:     6f67a00498abf8f0b29c2cecfce188c70be309d0
> Author:     Sam Ravnborg <sam@neptun.(none)>
> AuthorDate: Thu Oct 18 21:24:21 2007 +0200
> Committer:  Sam Ravnborg <sam@neptun.(none)>
> CommitDate: Thu Oct 18 23:17:06 2007 +0200
> 
>     kbuild: disable depmod in cross-compile kernel build
>     
>     When building embedded systems in a cross-compile environment and
>     populating a target's file system image, we don't want to run the
>     depmod on the host as we may be building for a completely different
>     architecture. Since there's no such thing as a cross-depmod, we
>     just disable running depmod in the cross-compile case and we just
>     run depmod on the target at bootup.
>     
>     Inspired by patches from Christian, Armin and Deepak.
>     
>     This solves: http://bugzilla.kernel.org/show_bug.cgi?id=3881
>     
>     Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
>     Cc: Christian Bjølevik <nafallo@magicalforest.se>
>     Cc: Deepak Saxena <dsaxena@mvista.com> and
>     Cc: Armin Kuster <akuster@mvista.com>,

Euh, is these really necessary?

At work I have no problems running depmod on an i386 system for ppc64 modules
after I installed module-init-tools 3.3-pre2 (from Debian).
I did have problems (depmod SEGV) using the depmod that came with CentOS
4 (from module-init-tools 3.1-pre5).

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
---1463808512-1964029385-1192988968=:6155--
