Return-Path: <linux-kernel-owner+w=401wt.eu-S933845AbXLPPXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933845AbXLPPXc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 10:23:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbXLPPXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 10:23:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35865 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093AbXLPPXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 10:23:23 -0500
Date: Sun, 16 Dec 2007 16:22:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rene Herman <rene.herman@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Paul Rolland <rol@as2917.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@ucw.cz>,
       "David P. Reed" <dpreed@reed.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
Message-ID: <20071216152250.GA21245@elte.hu>
References: <4762C551.5070003@zytor.com> <20071214210652.GB28793@elf.ucw.cz> <4763001A.1070102@zytor.com> <20071214232955.545ab809@the-village.bc.nu> <20071215080831.404cdb32@tux.DEF.witbe.net> <47638C8C.2090604@gmail.com> <476438B4.2020600@zytor.com> <476462BE.3030701@gmail.com> <4764687D.6080609@zytor.com> <476524DB.7020806@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476524DB.7020806@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rene Herman <rene.herman@gmail.com> wrote:

> Any ACKs, NAKs or further comments from others in this thread also 
> welcome.

looks good to me. Could you please also provide three more controls that 
i suggested earlier:

 - a boot option enabling/disabling the udelay based code
 - a .config method of enabling/disabling the udelay based code
 - a sysctl to toggle it

if we want to clean this all up we'll need as many controls as possible.

	Ingo
