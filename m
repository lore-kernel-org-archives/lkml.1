Return-Path: <linux-kernel-owner+w=401wt.eu-S1755955AbYHLOnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbYHLOnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 10:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755147AbYHLOlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 10:41:20 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55198 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754245AbYHLOlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 10:41:19 -0400
Date: Tue, 12 Aug 2008 15:24:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "jay kumar" <jaykumarks@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Bug: unable to handle kernel paging request
 2.6.27-rc2-next-20080811
Message-ID: <20080812152403.1f7ca9c0@lxorguk.ukuu.org.uk>
In-Reply-To: <6f31812b0808120615q278a6b3ar59ecc70e52c8a857@mail.gmail.com>
References: <6f31812b0808120615q278a6b3ar59ecc70e52c8a857@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Aug 2008 18:45:14 +0530
"jay kumar" <jaykumarks@gmail.com> wrote:

> Got the bug "unable to handle kernel paging request" on rebooting
> 2.6.27-rc2-next-20080811
> 
> method to reproduce:
> reboot the machine via xterm or gnome-terminal. observe the messages
> during the reboot in another machine's terminal which is connected to
> it through a serial port setup.
> 
> commit 299be36648adc14e4627173d00c18b11d08e5ecd
> Author: Stephen Rothwell <sfr@canb.auug.org.au>5ecd
> Date:   Mon Aug 11 16:30:46 2008 +1000

Actually it seems to be one of mine. Found what I think is your bug (and a
couple of its friends). Stomped them I hope with tonights push.

Alan
