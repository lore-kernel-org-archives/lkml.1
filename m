Return-Path: <linux-kernel-owner+w=401wt.eu-S1755063Ab0AMN5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063Ab0AMN5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 08:57:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754896Ab0AMN5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 08:57:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753606Ab0AMN5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 08:57:15 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Daniel Borkmann <danborkmann@googlemail.com>
Cc: Matt Mackall <mpm@selenic.com>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       netdev@oss.sgi.com
Subject: Re: [PATCH] netpoll: allow execution of multiple rx_hooks per interface
References: <4B4630C0.6090206@gmail.com> <4B467A4D.9070708@gmail.com>
	<1263252108.29868.4774.camel@calx>
	<20100111.155912.68138954.davem@davemloft.net>
	<1263254625.29868.4777.camel@calx> <4B4BBDA5.8010808@gmail.com>
	<4B4D1372.9060702@gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 13 Jan 2010 08:57:07 -0500
In-Reply-To: <4B4D1372.9060702@gmail.com> (Daniel Borkmann's message of "Wed,
	13 Jan 2010 01:27:30 +0100")
Message-ID: <x49ljg25cr0.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Borkmann <danborkmann@googlemail.com> writes:

> Daniel Borkmann wrote:
>> Matt Mackall wrote:
>>> On Mon, 2010-01-11 at 15:59 -0800, David Miller wrote:
>>>> From: Matt Mackall <mpm@selenic.com>
>>>> Date: Mon, 11 Jan 2010 17:21:48 -0600
>>>>
>>>>> Looks pretty good. Dave?
>>>>>
>>>>> Acked-by: Matt Mackall <mpm@selenic.com>
>>>> I don't like the loop for RX ARP processing.
>>>>
>>>> The packet contents aren't going to change, so doing basic
>>>> packet validation inside of the "for each RX client" loop
>>>> of arp_reply() doesn't make any sense.
>>> True. Dan, please help our poor compilers with some manual loop
>>> invariant motion.
>> 
>> Okay, true. I'll fix this by tomorrow and resend the patch.
>
> Here the fix of the RX ARP processing routine. Content that isn't
> going to change is out-of-loop.
> Successfully tested on my machines.

Against what tree does this patch apply?  It doesn't apply to Linus's
git tree.  Also, in the future, could you use the -p option to diff so
we can see what function or data structure is being modified?  It really
helps in reviewing.

Thanks!
Jeff
