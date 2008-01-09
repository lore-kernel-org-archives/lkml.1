Return-Path: <linux-kernel-owner+w=401wt.eu-S1754417AbYAIHXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbYAIHXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 02:23:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbYAIHX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 02:23:28 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:47401 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765AbYAIHX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 02:23:27 -0500
Date: Wed, 9 Jan 2008 08:23:25 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: "Cai, Cliff" <Cliff.Cai@analog.com>
Cc: "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] split MMC_CAP_4_BIT_DATA
Message-ID: <20080109082325.212ec90d@poseidon.drzeus.cx>
In-Reply-To: <0F1B54C89D5F954D8535DB252AF412FA014FAD4A@chinexm1.ad.analog.com>
References: <386072610801081832w2befcbafwe9215067f022ed5d@mail.gmail.com>
	<0F1B54C89D5F954D8535DB252AF412FA014FAD4A@chinexm1.ad.analog.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jan 2008 11:21:40 +0800
"Cai, Cliff" <Cliff.Cai@analog.com> wrote:

> 
>  Hi,all
> 
> I'd like to say something about this issue.
> Currently,the blackfin on chip SD host ONLY support 1-bit MMC while
> support 1-bit/4-bit SD/SDIO.
> And we want our driver to support both 1-bit MMC and 4-bit SD/SDIO.but
> the current MMC driver framework
> Only allow us to set one kind of bus width,either 1-bit or 4-bit.So in
> order to meet our case,we need more flexible mechanism
> To inform the upper commom driver to know our situation.
> 

That's just iterating what's already been said. My claim is that 4-bit is 4-bit, regardless if it's MMC or SD. So if you want this patch to go in you need to explain why there is a difference for the blackfin controller.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
