Return-Path: <linux-kernel-owner+w=401wt.eu-S1767535AbXEDAj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767535AbXEDAj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 20:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767544AbXEDAj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 20:39:26 -0400
Received: from terminus.zytor.com ([192.83.249.54]:53436 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767535AbXEDAjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 20:39:25 -0400
Message-ID: <463A80A9.7030809@zytor.com>
Date: Thu, 03 May 2007 17:39:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Kyle Moffett <mrmacman_g4@mac.com>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Albert Cahalan <acahalan@gmail.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, aeb@cwi.nl
Subject: Re: console font limits
References: <787b0d920704302109r352e6653wc71a0638cbfbdcce@mail.gmail.com> <Pine.LNX.4.64.0705011347300.27246@anakin> <1178021516.4372.62.camel@daplas> <46375738.1010007@zytor.com> <787b0d920705010849u52a4d6c3o2f1f800521ad5b95@mail.gmail.com> <Pine.LNX.4.61.0705021953030.18504@yvahk01.tjqt.qr> <787b0d920705022317j485cbe26wc83f071834c53584@mail.gmail.com> <Pine.LNX.4.61.0705030902430.18504@yvahk01.tjqt.qr> <787b0d920705030714k3b290d2csa38a5df63c692d6f@mail.gmail.com> <Pine.LNX.4.61.0705031621370.18504@yvahk01.tjqt.qr> <Pine.LNX.4.64.0705031754410.4727@anakin> <Pine.LNX.4.61.0705032020130.18504@yvahk01.tjqt.qr> <463A42DF.5030409@zytor.com> <Pine.LNX.4.61.0705032216200.18504@yvahk01.tjqt.qr> <E0FF8D28-219F-44D5-88B4-BDE6A4D6605A@mac.com>
In-Reply-To: <E0FF8D28-219F-44D5-88B4-BDE6A4D6605A@mac.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett wrote:
> 
> Actually I think the real problem was that "KD_GRAPHICS" got overloaded
> to mean "some userspace program is probably poking at the GPU in very
> direct ways possibly including /dev/mem".  As such it really isn't safe
> at all for the kernel to write stuff to the screen in that situation;
> you could turn a panic()+reboot-after-30-secs into an unrecoverable hard
> PCI bus lockup.  IIRC there were at least a couple chipsets which had
> that problem with X.  If we can implement enough APIs for X to do all of
> its stuff from userspace without iopl() or /dev/mem then we could
> probably bring back the option for dumping oopses to screen in
> KD_GRAPHICS mode, but otherwise it'll just cause more headaches.
> 

It never meant anything *BUT* that, to the best of my knowledge.  That
was certainly the original meaning of KD_GRAPHICS.

	-hpa
