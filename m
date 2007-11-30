Return-Path: <linux-kernel-owner+w=401wt.eu-S933375AbXK3G74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933375AbXK3G74 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 01:59:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757374AbXK3G7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 01:59:44 -0500
Received: from smtp.witbe.net ([81.88.96.48]:59032 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757312AbXK3G7n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 01:59:43 -0500
Date: Fri, 30 Nov 2007 07:59:32 +0100
From: Paul Rolland (=?UTF-8?Q?=E3=83=9D=E3=83=BC=E3=83=AB=E3=83=BB?=
	=?UTF-8?Q?=E3=83=AD=E3=83=A9=E3=83=B3?=) <rol@witbe.net>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, rol@witbe.net
Subject: Re: constant_tsc and TSC unstable
Message-ID: <20071130075932.7f1f0974@tux.DEF.witbe.net>
In-Reply-To: <474F2E97.5080802@msgid.tls.msk.ru>
References: <20071129171142.56c7890a@tux.DEF.witbe.net>
	<474F0D47.7020006@zytor.com>
	<474F2E97.5080802@msgid.tls.msk.ru>
Organization: Witbe.net
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i686-pc-linux-gnu)
X-Ncc-RegId: fr.witbe
X-Face: +^rP^g;Vjb!M*"%3$mF6xWU{DwwAx)W=b_<WXQMv}Rk8,fQ)?Wnk0NK/+m,;eWci?+;=I}d^:]I+)D+|r'vxjYjp.?o-8Va|&sD*-GVKn>}?Y)|*X<5cv@M`1P{\:)p9_:$=)(NY2`%AcypV*]z>YIyy5yY"9PUoV5@)*(W:S5e-48Ct7Wu6CkkO[=KB"ox,_2B/FwY&hr/E1H&<9IbOCx6NrBa"}FLA)UIvHg`9%NC\LfYB3ia]
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, 30 Nov 2007 00:26:47 +0300
Michael Tokarev <mjt@tls.msk.ru> wrote:

> H. Peter Anvin wrote:
> > Paul Rolland (ポール・ロラン) wrote:
> []
> >> Measured 3978592228 cycles TSC warp between CPUs, turning off TSC clock.
> >> Marking TSC unstable due to: check_tsc_sync_source failed.
> []
> >> but I was wondering if this is a bug or a feature ;)
> 
> > The problem you're having is that the TSCs of your two cores are
> > completely different, over a second apart.  This is a bug, unrelated to
> > constant_tsc.
> 
> A bug in where - in the CPU or in kernel?
Good question !
 
> The thing is that all our dual-core machines shows something like
> that.
> 
> (not that huge difference as Paul reported, but still "unstable".
> The same happens with 2.6.23)
I've been checking my logs, and the difference is quite constant and
huge :
[root@tux log]# grep 'cycles TSC warp' messages*
messages:Nov 26 08:27:56 tux kernel: Measured 4078687691 cycles TSC warp between C
PUs, turning off TSC clock.
messages:Nov 26 17:21:21 tux kernel: Measured 3978592228 cycles TSC warp between C
PUs, turning off TSC clock.
messages.1:Nov 18 22:52:23 tux kernel: Measured 4063102940 cycles TSC warp between
 CPUs, turning off TSC clock.
messages.1:Nov 19 07:19:02 tux kernel: Measured 4057192061 cycles TSC warp between
 CPUs, turning off TSC clock.
messages.1:Nov 23 20:50:12 tux kernel: Measured 4064589321 cycles TSC warp between
 CPUs, turning off TSC clock.
messages.2:Nov 12 08:06:44 tux kernel: Measured 4072130361 cycles TSC warp between
 CPUs, turning off TSC clock.
messages.2:Nov 13 19:42:47 tux kernel: Measured 4049899451 cycles TSC warp between
 CPUs, turning off TSC clock.
messages.2:Nov 17 09:27:22 tux kernel: Measured 4066629060 cycles TSC warp between
 CPUs, turning off TSC clock.
messages.3:Nov  5 08:25:08 tux kernel: Measured 4086386109 cycles TSC warp between
 CPUs, turning off TSC clock.
messages.3:Nov  8 13:07:08 tux kernel: Measured 4041945934 cycles TSC warp between
 CPUs, turning off TSC clock.
messages.3:Nov  9 23:31:24 tux kernel: Measured 4092303059 cycles TSC warp between
 CPUs, turning off TSC clock.
messages.4:Oct 29 07:28:23 tux kernel: Measured 4096946373 cycles TSC warp between
 CPUs, turning off TSC clock.
messages.4:Oct 31 17:07:21 tux kernel: Measured 4046765372 cycles TSC warp between
 CPUs, turning off TSC clock.
messages.4:Oct 31 17:15:09 tux kernel: Measured 4039328228 cycles TSC warp between
 CPUs, turning off TSC clock.
messages.4:Oct 31 23:19:00 tux kernel: Measured 4069714246 cycles TSC warp between
 CPUs, turning off TSC clock.
messages.4:Nov  1 20:33:02 tux kernel: Measured 4088199726 cycles TSC warp between
 CPUs, turning off TSC clock.
messages.4:Nov  2 11:53:17 tux kernel: Measured 4079927527 cycles TSC warp between
 CPUs, turning off TSC clock.
messages.4:Nov  3 09:37:16 tux kernel: Measured 4071112656 cycles TSC warp between
 CPUs, turning off TSC clock.
messages.4:Nov  3 10:51:29 tux kernel: Measured 3986266219 cycles TSC warp between
 CPUs, turning off TSC clock.
messages.4:Nov  4 18:14:56 tux kernel: Measured 4074214144 cycles TSC warp between
 CPUs, turning off TSC clock.

> Note that once TSC is disabled (it's using "jiffies" as far
> as I can see), ntpd constantly speeds up and slows down the
> clock, it jumps +/- 0.5sec every several minutes or hours -
> I guess that's when ntpd process gets moved from one core
> to another for whatever reason.  And an interesting thing
> is that with 64bits kernel this TSC problem does not occur
> on this very machine.
Hmmmm.... That could make it a problem related to kernel rather than CPU.
 
> Something similar is reported on AMD X2 64 machines as well --
> can't check right now.
If I recall correctly, issues with AMD X2 where related to TSC being
independant for each core and not constant (speed depending of C state).
But the reason I raise the issue is that the Core2 reports constant TSC,
so there is (IMHO) no reason for that.

Paul

