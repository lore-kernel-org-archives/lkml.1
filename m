Return-Path: <linux-kernel-owner+w=401wt.eu-S1756310AbZJLNGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310AbZJLNGQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 09:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755293AbZJLNGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 09:06:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53652 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755131AbZJLNGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 09:06:15 -0400
Date: Mon, 12 Oct 2009 14:06:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [crash] NULL pointer dereference at IP: [<ffffffff812e9ccb>]
 uart_close+0x2a/0x1e4
Message-ID: <20091012140646.17bce0df@lxorguk.ukuu.org.uk>
In-Reply-To: <20091012122245.GA22088@elte.hu>
References: <alpine.LFD.2.01.0910111446410.3438@localhost.localdomain>
	<20091012080511.GA22607@elte.hu>
	<20091012091954.GA31171@elte.hu>
	<20091012092713.GA32647@elte.hu>
	<20091012112504.GA10002@elte.hu>
	<20091012124501.3c1ac94f@lxorguk.ukuu.org.uk>
	<20091012115549.GA13987@elte.hu>
	<20091012122245.GA22088@elte.hu>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> BUG: unable to handle kernel NULL pointer dereference at 0000000000000240
> IP: [<ffffffff812ea215>] uart_close+0x24/0x1e5

Very odd indeed. Can you dump the value of

	state (ie tty->driver_data)

	and if state is non NULL

	state->uart_port

in the crash case

and if state->uart_port is NULL then there is some head scratching
required 
