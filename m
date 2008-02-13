Return-Path: <linux-kernel-owner+w=401wt.eu-S1755143AbYBML0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143AbYBML0R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 06:26:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755594AbYBML0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 06:26:03 -0500
Received: from smtp2.sssup.it ([193.205.80.100]:60228 "EHLO smpt.sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755492AbYBML0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 06:26:01 -0500
Message-ID: <47B2CF76.6050704@gandalf.sssup.it>
Date: Wed, 13 Feb 2008 12:07:34 +0100
From: michael <trimarchi@gandalf.sssup.it>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Remy Bohmer <linux@bohmer.net>
CC: Haavard Skinnemoen <hskinnemoen@atmel.com>, fabio@gandalf.sssup.it,
       Andrew Victor <linux@maxim.org.za>, Chip Coldwell <coldwell@redhat.com>,
       Marc Pignat <marc.pignat@hevs.ch>, David Brownell <david-b@pacbell.net>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH -mm v4 6/9] atmel_serial: Split the interrupt handler
References: <20080129224316.GA23155@gandalf.sssup.it>	 <20080130133659.55ebd828@dhcp-252-066.norway.atmel.com>	 <47A09723.7020000@gandalf.sssup.it>	 <20080130164631.7de4f6bd@dhcp-252-066.norway.atmel.com>	 <47A12A2E.5040309@gandalf.sssup.it>	 <20080131160721.6dddf30e@dhcp-252-066.norway.atmel.com>	 <3efb10970801311136y12670f12x6e4fdd44de3677b9@mail.gmail.com>	 <20080204133925.73733f5f@dhcp-252-066.norway.atmel.com>	 <3efb10970802041144j6b4e6893j293819238b5b82e8@mail.gmail.com>	 <47A9A5B5.3060800@gandalf.sssup.it> <3efb10970802061141x5fdecefao8f617265aed7cb6f@mail.gmail.com>
In-Reply-To: <3efb10970802061141x5fdecefao8f617265aed7cb6f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

All works now for me with preempt-rt. The problem is using hrtimer.

I think that hrtimer are executed with interrupts disabled so, if
this happen when I must receive a char, i have an overrun. The only
solution was the dma support to serial device.

Regards Michael

