Return-Path: <linux-kernel-owner+w=401wt.eu-S1756755AbYJHV6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbYJHV6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 17:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754608AbYJHV6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 17:58:37 -0400
Received: from khc.piap.pl ([195.187.100.11]:32806 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551AbYJHV6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 17:58:36 -0400
To: "Jon Smirl" <jonsmirl@gmail.com>
Cc: "Bill Gatliff" <bgat@billgatliff.com>,
       "ARM Linux Mailing List" <linux-arm-kernel@lists.arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Toggling GPIO at 38Khz
References: <9e4733910810072043m6c69f3bdv104bd32928fe64ae@mail.gmail.com>
	<48ECA101.8010604@billgatliff.com>
	<9e4733910810080606ne8bdbb8v81d42069c985ae98@mail.gmail.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Wed, 08 Oct 2008 23:58:34 +0200
In-Reply-To: <9e4733910810080606ne8bdbb8v81d42069c985ae98@mail.gmail.com> (Jon Smirl's message of "Wed\, 8 Oct 2008 09\:06\:30 -0400")
Message-ID: <m363o292b9.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Jon Smirl" <jonsmirl@gmail.com> writes:

> These are external boards people buy to use with MythTV. They are most
> commonly used on the x86, but the NSLU2 has been modified to use them
> too.
>
> The hardware can't be changed, people have bought thousands of these devices.
>
> Many people cut up a serial cable and solder it themselves...

Sure but you only need to bit-bang at 36 or so kHz while transmitting,
right? The receive side is a slow one as the receiver chip has an
integrated "demodulator".

If so then personally... I'd abandon the simple TX circuit, and use
a hardware ~36 kHz oscillator, gated by the serial output signal.
I don't think such transmitters are in thousands. Tens, maybe - the
cost of replacing/modifying them all should be insignificant. I guess
one could design and produce such a TXer in less than 20 minutes.
-- 
Krzysztof Halasa
