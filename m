Return-Path: <linux-kernel-owner+w=401wt.eu-S1759916AbYAKKFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759916AbYAKKFZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 05:05:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755149AbYAKKFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 05:05:12 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:53242 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754333AbYAKKFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 05:05:10 -0500
Date: Fri, 11 Jan 2008 11:05:05 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Cc: "Bryan Wu" <cooloney.lkml@gmail.com>, "Cai, Cliff" <Cliff.Cai@analog.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] split MMC_CAP_4_BIT_DATA
Message-ID: <20080111110505.615ae436@poseidon.drzeus.cx>
In-Reply-To: <8bd0f97a0801110147w1cc741c3yc80ad32cd0e896c9@mail.gmail.com>
References: <386072610801081832w2befcbafwe9215067f022ed5d@mail.gmail.com>
	<20080109082325.212ec90d@poseidon.drzeus.cx>
	<386072610801090845r14510fb8tbcca76d605458a96@mail.gmail.com>
	<20080110095428.3b93fd18@poseidon.drzeus.cx>
	<386072610801100122n52339488ke2b8724c390be765@mail.gmail.com>
	<20080110125748.416ad0c5@poseidon.drzeus.cx>
	<386072610801102217u1739d7d7v497e73a38aa876c2@mail.gmail.com>
	<20080111094036.4c683791@poseidon.drzeus.cx>
	<8bd0f97a0801110108l66ab2bcdjb1323573445473f@mail.gmail.com>
	<20080111103532.2789b74f@poseidon.drzeus.cx>
	<8bd0f97a0801110147w1cc741c3yc80ad32cd0e896c9@mail.gmail.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jan 2008 04:47:44 -0500
"Mike Frysinger" <vapier.adi@gmail.com> wrote:

> Cliff should be able to enumerate the cards he has tested and the
> issues he's run into.  i'll see if i cant get more in depth
> information from the hardware guys beyond the documentation on the sdh
> already available in the hardware manual (which i'm guessing has not
> been enough to appease you).
> 

Great. And you're right in that the spec did not give any indication that MMC shouldn't work.

I did notice one thing though. The pull-ups and pull-downs seem to be controllable. If I remember correctly, DAT3 needs to have a controller-side pull-up for MMC cards. And the docs said the default was not to provide that (in order to use the internal pull-up that most, but not all, SD cards have for detection). Might be something to look at if you haven't already.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
