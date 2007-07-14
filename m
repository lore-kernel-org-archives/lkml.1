Return-Path: <linux-kernel-owner+w=401wt.eu-S1765315AbXGNUdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765315AbXGNUdz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 16:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763039AbXGNUdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 16:33:33 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46647 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761022AbXGNUdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 16:33:32 -0400
Message-ID: <46993317.3070203@garzik.org>
Date: Sat, 14 Jul 2007 16:33:27 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Mike Frysinger <vapier.adi@gmail.com>, bryan.wu@analog.com,
       LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] Blackfin ethernet driver: on chip ethernet MAC controller
 driver
References: <1184438993.3140.23.camel@roc-laptop> <200707142138.36619.mb@bu3sch.de> <8bd0f97a0707141249y2c90a59cs356aa3cef357f721@mail.gmail.com> <200707142217.36361.mb@bu3sch.de>
In-Reply-To: <200707142217.36361.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Buesch wrote:
> Well, this bitfield _might_ be OK (although I don't like bitfields
> at all), but the above pointer casting stuff should really use
> leXX_to_cpu. It's so easy to use and it is easier to read and
> maintain the code afterwards.
> If the bitfield stays, a comment must be added.

Regardless of endian issues, the bitfield usage should go away.

	Jeff


