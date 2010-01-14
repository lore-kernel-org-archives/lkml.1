Return-Path: <linux-kernel-owner+w=401wt.eu-S1754032Ab0ANU5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab0ANU5s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 15:57:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932151Ab0ANU5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 15:57:47 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45608 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752043Ab0ANU5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 15:57:45 -0500
Date: Thu, 14 Jan 2010 21:00:50 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>, linux-ide@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: SATA_SIL on IXP425 workaround
Message-ID: <20100114210050.2c99c2b1@lxorguk.ukuu.org.uk>
In-Reply-To: <201001142129.38781.bzolnier@gmail.com>
References: <m33a4nfvva.fsf@intrepid.localdomain>
	<201001141659.19687.bzolnier@gmail.com>
	<20100114192210.62593ead@lxorguk.ukuu.org.uk>
	<201001142129.38781.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think that you misinterpreted the issue -- according to Krzysztof MMIO
> works just fine, only 8/16-bit MMIO reads are a problem (please note that
> using mixed PIO/MMIO access is still a win over pure PIO access and also
> that sata_sil doesn't support pure non-MMIO operations currently)..

Have we got timing measurements to prove that ?
> 
> However if it gets fixed in the upstream kernel in some other way I'll
> simply drop the patch during the next re-base of my tree (I just collect
> ATA stuff that looks useful/interesting to me and which otherwise may
> become lost)..

And that's a good thing. The question was aimed at Krzysztof. Really we
need to keep platform specific weirdness out of core drivers or the
rapidly turn into a mess.
