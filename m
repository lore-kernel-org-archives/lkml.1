Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab0BBG6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 01:58:45 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:35300 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830Ab0BBG6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 01:58:42 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Andreas Mohr <andi@lisas.de>
Subject: Re: USB mass storage and ARM cache coherency
Date: Tue, 2 Feb 2010 07:58:42 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc3-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>, linux-usb@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Sebastian Siewior <bigeasy@linutronix.de>, Greg KH <greg@kroah.com>,
       Takashi Iwai <tiwai@suse.de>
References: <20100129185434.GH19501@one-eyed-alien.net> <1265045354.25750.52.camel@pc1117.cambridge.arm.com> <20100201223001.GA17627@rhlx01.hs-esslingen.de>
In-Reply-To: <20100201223001.GA17627@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002020758.42141.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 1. Februar 2010 23:30:01 schrieb Andreas Mohr:
> I took some time to add your patch to ehci-q.c / ohci-q.c
> (for my *hci-ssb.c ASUS WL-500gP v2), on my now heavily patched-up 2.6.31.9,
> but UNFORTUNATELY it kept locking up the same way as always when stopping
> playback despite being damn sure this time that this patch could have
> the potential to finally fix it ;)
> (I had to replace memory.h with page.h on my arch though, to fix the build)

A moment please. You are using ehci and ohci. Both are using dma.
Why does this issue arise?

	Regards
		Oliver
