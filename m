Return-Path: <linux-kernel-owner+w=401wt.eu-S1760304AbYAKIkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760304AbYAKIkz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 03:40:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760153AbYAKIkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 03:40:45 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:46025 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760121AbYAKIkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 03:40:43 -0500
Date: Fri, 11 Jan 2008 09:40:36 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: "Bryan Wu" <cooloney.lkml@gmail.com>
Cc: "Cai, Cliff" <Cliff.Cai@analog.com>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] split MMC_CAP_4_BIT_DATA
Message-ID: <20080111094036.4c683791@poseidon.drzeus.cx>
In-Reply-To: <386072610801102217u1739d7d7v497e73a38aa876c2@mail.gmail.com>
References: <386072610801081832w2befcbafwe9215067f022ed5d@mail.gmail.com>
	<0F1B54C89D5F954D8535DB252AF412FA014FAD4A@chinexm1.ad.analog.com>
	<20080109082325.212ec90d@poseidon.drzeus.cx>
	<386072610801090845r14510fb8tbcca76d605458a96@mail.gmail.com>
	<20080110095428.3b93fd18@poseidon.drzeus.cx>
	<386072610801100122n52339488ke2b8724c390be765@mail.gmail.com>
	<20080110125748.416ad0c5@poseidon.drzeus.cx>
	<386072610801102217u1739d7d7v497e73a38aa876c2@mail.gmail.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jan 2008 14:17:01 +0800
"Bryan Wu" <cooloney.lkml@gmail.com> wrote:

> We were told this is an hardware design issue, so please help us to
> workaround it in software side with Mike's patch.

I'm afraid that's insufficient motivation for this change. All documentation and real world tests say that MMC and SD 4-bit data is 100% compatible. So it's far more probable that you've misdiagnosed your error than this being the actual problem. The fact that 4-bit MMC support has been present for some time and you're only now seeing a problem further supports that.

In light of that, the suggested patch would not only be incorrect, it would also be worse than doing nothing. You would be papering over a symptom, making the real problem harder to find.

If you want something ready for upstream, for now I suggest removing MMC_CAP_4_BIT_DATA completely from your driver's caps field.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
