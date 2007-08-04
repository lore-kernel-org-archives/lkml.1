Return-Path: <linux-kernel-owner+w=401wt.eu-S1765731AbXHDVJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765731AbXHDVJ5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 17:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760053AbXHDVJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 17:09:48 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:44029
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758134AbXHDVJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 17:09:47 -0400
Message-ID: <46B4F8AD.3000405@microgate.com>
Date: Sat, 04 Aug 2007 16:07:41 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Lee Howard <faxguy@howardsilvan.com>
CC: Ray Lee <ray-lk@madrabbit.org>, Tilman Schmidt <tilman@imap.cc>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Robert Hancock <hancockr@shaw.ca>,
       linux-serial@vger.kernel.org, tytso@mit.edu, rmk@arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: serial flow control appears broken
References: <fa.Z6O0xFRT69zes0Mg+agt3Uiwux4@ifi.uio.no>	 <46A84B4A.6070902@shaw.ca> <46A8C6F1.4080309@howardsilvan.com>	 <20070726173121.70088a92@the-village.bc.nu>	 <46A98845.8010806@howardsilvan.com> <46A9F712.70706@imap.cc>	 <46D33636.7070200@microgate.com> <46AA5A0E.1050600@howardsilvan.com>	 <1185578908.2989.15.camel@x2> <46AACB4D.7080004@howardsilvan.com> <2c0942db0707280941n1b9e1f7i9c0de332286e8aac@mail.gmail.com> <46B4C393.4020506@howardsilvan.com>
In-Reply-To: <46B4C393.4020506@howardsilvan.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lee Howard wrote:
> And in repeat tests it is quite evident that IDE disk activity is, 
> indeed, at least part of the problem.  As IDE disk activity increases an 
> increased amount of data coming in on the serial port goes missing.

Lee, you mentioned 2.2.x kernels did not exhibit this problem.

Was this on the same hardware you are currently testing?
Which 2.2.x version were you using?
Was the 2.2.x serial driver also identifying the UART as a 16550A?
Can you get /proc/interrupts output
from both the current setup and the 2.2.x setup?

It would be interesting to compare the interrupt
assignment and UART setup between the versions.

--
Paul
