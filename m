Return-Path: <linux-kernel-owner+w=401wt.eu-S1763859AbXE1XA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763859AbXE1XA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 19:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758897AbXE1XAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 19:00:15 -0400
Received: from fmmailgate09.web.de ([217.72.192.184]:57763 "EHLO
	fmmailgate09.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758637AbXE1XAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 19:00:13 -0400
Date: Tue, 29 May 2007 01:00:12 +0200
Message-Id: <18025041@web.de>
MIME-Version: 1.0
From: Uwe Bugla <saubermann60@web.de>
To: linux-kernel@vger.kernel.org
Subject: Re: b44: regression in 2.6.22 (resend)
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX19AOkBpUCmss5R83I+aIno1vBloXJy6Mnrf4TdNuaAGE/A2O
 Ipggf7ZyItFabKLgOTexcrTnbUh2929FrQbxJvpf/4MvhRFv1dMZgzm8XxWn
 w==
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-28 at 22:55 +0200, Maximilian Engelhardt wrote:
> > > I additionally built my 2.6.22-rc2-mm1 kernel without High Resolution
> > > Timer, but the high ping problem is still there.
> >
> > Hmm, that's mysterious. Wild guess is that highres exposes the hidden
> > "feature" in a different way than rc2-mm1 does.
>
> I think the bug in 2.6.21/22-rc3 is a different one that the one in
> 2.6.22-rc2-mm1, but that's also only a wild guess :)
>
> I'll explain this a bit:
> In 2.6.21/22-rc3 is the same b44 driver that has been in the stock kernels for
> some time. With this driver and High Resolution Timer turned on I get
> problems using iperf. The problems are that the systems becomes really slow
> and unresponsive. Michael Buesch thought this could be an IRQ storm which
> sounds logical to me. This bug did never happen to me before I startet the
> iperf test.

Can you please apply

http://www.tglx.de/projects/hrtimers/2.6.22-rc3/patch-2.6.22-rc3-hrt1.patch

on top of rc3 and check, whether it has any effect on your problem.

> The other issue happens only with 2.6.22-rc2-mm1 which includes the b44 ssb
> spilt. It's independed wether High Resolution Timer is turned on or off I
> always get very varying and high ping times. The iperf-test doesn't show the
> problems from 2.6.21/22-rc3.

Neither with nor without highres ?

tglx

Neither with nor without Gleixner ?

Neither with nor without Buesch ?

Neither with nor without Miller ?

Neither with nor without Kyle ?

Neither with nor without ........ ?

Neither with nor without would-like-to-spare time hackers ?

Neither with nor without profile neurotic would-like-to-copyright owners ?

_______________________________________________________________
SMS schreiben mit WEB.DE FreeMail - einfach, schnell und
kostenguenstig. Jetzt gleich testen! http://f.web.de/?mc=021192

