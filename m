Return-Path: <linux-kernel-owner+w=401wt.eu-S1763578AbZFKMC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763578AbZFKMC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 08:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbZFKMCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 08:02:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50449
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750749AbZFKMCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 08:02:18 -0400
Date: Thu, 11 Jun 2009 05:02:20 -0700 (PDT)
Message-Id: <20090611.050220.179261434.davem@davemloft.net>
To: tiwai@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: sound skipping regression introduced in 2.6.30-rc8
From: David Miller <davem@davemloft.net>
In-Reply-To: <s5hzlcflw2d.wl%tiwai@suse.de>
References: <20090610.112804.193703669.davem@davemloft.net>
	<s5hzlcflw2d.wl%tiwai@suse.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>
Date: Wed, 10 Jun 2009 21:37:14 +0200

> Also, it'd be helpful if you can check whether the problem exists in
> the current sound git tree (for-linus branch), too.
>   git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6.git for-linus

Same behavior as 2.6.30, but debugging messages are formatted differently
:-)

[ 1109.062182] PCM: Lost interrupts? (stream=0, delta=16384, intr_ptr=73728)
[ 1125.126123] PCM: Lost interrupts? (stream=0, delta=16384, intr_ptr=861184)
[ 1131.398094] PCM: Lost interrupts? (stream=0, delta=16384, intr_ptr=1178624)
[ 1135.579406] PCM: Lost interrupts? (stream=0, delta=16384, intr_ptr=1395712)
[ 1145.115367] PCM: Lost interrupts? (stream=0, delta=16384, intr_ptr=1869824)
[ 1152.688670] PCM: Lost interrupts? (stream=0, delta=16384, intr_ptr=2249728)
