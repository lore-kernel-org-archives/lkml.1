Return-Path: <linux-kernel-owner+w=401wt.eu-S1765143AbXLPJ2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765143AbXLPJ2d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 04:28:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755761AbXLPJ2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 04:28:25 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:32777 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755676AbXLPJ2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 04:28:24 -0500
Date: Sun, 16 Dec 2007 10:27:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Paul Rolland <rol@as2917.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@ucw.cz>, "David P. Reed" <dpreed@reed.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, Rene Herman <rene.herman@keyaccess.nl>,
       rol@witbe.net
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80
	on some AMD64x2 laptops, etc.
Message-ID: <20071216092757.GC27280@elte.hu>
References: <469697C6.50903@reed.com> <1184274754.12353.254.camel@chaos> <4761F193.7090400@reed.com> <20071214131502.GA14359@elte.hu> <4762C551.5070003@zytor.com> <20071214210652.GB28793@elf.ucw.cz> <4763001A.1070102@zytor.com> <20071214232955.545ab809@the-village.bc.nu> <20071215080831.404cdb32@tux.DEF.witbe.net> <47643872.5070703@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47643872.5070703@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> Paul Rolland wrote:
>> Just an idea : from what I've read, the problem (port 80 hanging) only occurs
>> on 'modern' machines...
>
> It happens on *one single* "modern" machine...
>
> Let's keep that in perspective.

two or three i think (and an unknown of others where "random, 
unexplained freezes" were thought to be hw borkage), but yeah, it's 
still a very low proportion.

	Ingo
