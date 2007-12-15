Return-Path: <linux-kernel-owner+w=401wt.eu-S1761668AbXLOQtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761668AbXLOQtQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 11:49:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754329AbXLOQtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 11:49:00 -0500
Received: from rtr.ca ([76.10.145.34]:4305 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754144AbXLOQs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 11:48:59 -0500
Message-ID: <47640579.3000706@rtr.ca>
Date: Sat, 15 Dec 2007 11:48:57 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "David P. Reed" <dpreed@reed.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Rene Herman <rene.herman@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, Rene Herman <rene.herman@keyaccess.nl>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80
 on some AMD64x2 laptops, etc.
References: <1184218962.12353.209.camel@chaos>	<46964352.7040301@reed.com>	<1184253339.12353.223.camel@chaos>	<469697C6.50903@reed.com>	<1184274754.12353.254.camel@chaos>	<4761F193.7090400@reed.com>	<20071214131502.GA14359@elte.hu>	<4762C551.5070003@zytor.com>	<20071215074358.GD12110@elte.hu>	<4763891A.3010004@gmail.com>	<20071215132725.GA23166@elte.hu> <20071215142929.5462b329@the-village.bc.nu> <4763FE7A.4000105@reed.com>
In-Reply-To: <4763FE7A.4000105@reed.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change seems rather unlikely for 2.6.24 at this point (high risk),
but could be good for 2.6.25.

One thing it should probably have for the early going,
is a simple way to turn it on/off at boot time,
so that we don't have people "stuck" unable to run
the test kernels should something weird happen.

Alan / David / Ingo,

What do you think of the idea of a *temporary* boot flag for this,
something like port80=on/off (pick a suitable name) ?

Cheers
