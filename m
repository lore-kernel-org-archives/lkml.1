Return-Path: <linux-kernel-owner+w=401wt.eu-S1755866AbYK2KTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbYK2KTR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 05:19:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbYK2KS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 05:18:58 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:54364 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751103AbYK2KS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 05:18:57 -0500
X-Sasl-enc: e+OFJzL8YfyXWSVMT2+OMXjUAgZL1Rs0UNKpy1PyUwBl 1227953935
Date: Sat, 29 Nov 2008 10:18:49 +0000
From: James Le Cuirot <chewi@aura-online.co.uk>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, suspend-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>, netdev@vger.kernel.org
Subject: Re: [Suspend-devel] TAP (and TUN?) devices not working after resume
Message-ID: <20081129101849.277ba756@symphony>
In-Reply-To: <48894D88.9010104@qualcomm.com>
References: <20080714154720.791f6640@symphony>
	<200807141812.45264.rjw@sisk.pl>
	<48894D88.9010104@qualcomm.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jul 2008 20:50:32 -0700
Max Krasnyansky <maxk@qualcomm.com> wrote:

> > On Monday, 14 of July 2008, James Le Cuirot wrote:  
> >>
> >> Hi,
> >>
> >> uswsusp works great on my machine except for one thing. I use a TAP
> >> device for QEMU and after resuming from suspend, it doesn't work
> >> anymore until I delete it and recreate it. This is rather annoying
> >> because if I have QEMU open, it means I have to close it before
> >> recreating the interface and then boot Windows up again. I use
> >> OpenVPN to create/delete the interface but I think that's all it
> >> does. The rest is done by the kernel. So I'm guessing something's
> >> up with the TUN/TAP driver or uswsusp itself. I'm using version
> >> 0.8. Sorry if this has already been fixed.  
> 
> I bet it's flow control related. I've fixed a bug in flow control
> handling for persistent devices recently.
> btw Does it still happen with >= 2.6.26 ?
> 
> I'll play with some test code on my laptop and see if I can reproduce
> this issue.
> 
> Max

Sorry about the crazy delay here, I didn't need to use QEMU for ages
and I don't like firing up Windows unless I have too. :D I'm not sure
about 2.6.26 but this appears to be fixed in 2.6.27.

Thanks,
James
