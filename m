Return-Path: <linux-kernel-owner+w=401wt.eu-S1756027AbYKDTW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbYKDTW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 14:22:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbYKDTWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 14:22:48 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43006 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751651AbYKDTWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 14:22:47 -0500
Date: Tue, 4 Nov 2008 19:22:53 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Chris Friesen" <cfriesen@nortel.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [BUG] serial base baud misdetected in 2.6.27
Message-ID: <20081104192253.151d6ef3@lxorguk.ukuu.org.uk>
In-Reply-To: <4910936D.4030605@nortel.com>
References: <4910936D.4030605@nortel.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Nov 2008 12:24:45 -0600
"Chris Friesen" <cfriesen@nortel.com> wrote:

> 
> I'm running an ATCA7101 board.  This board has two 16550 ports that get 
> detected as ttyS4 and ttyS5.
> 
> With a much earlier kernel (2.6.14) the serial port base speed is 
> correctly detected as 230400, which gives the desired 115200 when I 
> specify that on the kernel commandline.
> 
> With 2.6.16 and 2.6.27 (not sure about the intervening kernels) the 
> serial port base speed is detected as 921600, which means that I need to 
> specify 460800 on the commandline to get a real speed of 115200 (as 
> verified by an external terminal server).
> 
> Any ideas what could be causing this misdetection?  I'm having lab 
> issues right now so I can't track it down, but I'll have a go at it 
> eventually.

If this is a PCI card it may be matching against a PCI entry for a
similar card with different crystals and need the right svid/sdid adding.
