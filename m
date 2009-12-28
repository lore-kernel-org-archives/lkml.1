Return-Path: <linux-kernel-owner+w=401wt.eu-S1752411AbZL1Kes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbZL1Kes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 05:34:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbZL1Keo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 05:34:44 -0500
Received: from mail.gmx.net ([213.165.64.20]:34981 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752311AbZL1Kem convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 05:34:42 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/mqbE4n4zmnWzMUNq9nuc+1iXHq/3LlBeGN9s7Yb
	NDdJm6Vya/6bPY
From: Peter =?utf-8?q?H=C3=BCwe?= <PeterHuewe@gmx.de>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH] arch/avr32: Fix build failure for avr32 caused by typo
Date: Mon, 28 Dec 2009 11:34:36 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.27-05415-g69a8594; KDE/4.3.3; x86_64; ; )
Cc: "Hans-Christian Egtvedt" <hans-christian.egtvedt@atmel.com>,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Ma <pma@mediamatech.com>, linux-kernel@vger.kernel.org,
       linux-mmc@vger.kernel.org
References: <200912252008.45602.PeterHuewe@gmx.de> <200912281059.30450.PeterHuewe@gmx.de> <20091228112028.5babace2@hskinnemoen-d830>
In-Reply-To: <20091228112028.5babace2@hskinnemoen-d830>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200912281134.36763.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 28 Dezember 2009 11:20:28 schrieb Haavard Skinnemoen:
> Peter Hüwe <PeterHuewe@gmx.de> wrote:
> > Great, thanks for the update.
> > The only thing that still catches my eye is that the kzalloc line can
> > fail, so you should perhaps add something like
> > if (!slave) {
> > 	printk(KERN_ERR "No memory left for at32ap700x: at32_add_device_mc");
> > 	goto fail;
> > }
> 
> I agree, except that this is extremely unlikely to happen, so we should
> either drop the printk() or use pr_debug() in order to waste as little
> memory as possible in production systems.
ok.

> 
> I think your first patch is good as it is, so I will apply it. Please
> send any additional fixes as a separate patch.

Okay thanks for applying.

@Hans: can you create the cleanup patch or should I ?

Regards,
Peter
