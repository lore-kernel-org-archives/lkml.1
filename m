Return-Path: <linux-kernel-owner+w=401wt.eu-S1755741AbYGHTZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741AbYGHTZQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 15:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753921AbYGHTZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 15:25:05 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60558 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753905AbYGHTZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 15:25:03 -0400
Date: Tue, 8 Jul 2008 19:52:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: kyle@mcmartin.ca
Cc: kmcmartin@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] padlock: don't whinge when loaded on a non-VIA cpu
Message-ID: <20080708195211.1565f3d1@the-village.bc.nu>
In-Reply-To: <20080708190427.GA28899@phobos.i.cabal.ca>
References: <20080708190427.GA28899@phobos.i.cabal.ca>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jul 2008 15:04:27 -0400
Kyle McMartin <kmcmartin@redhat.com> wrote:

> I've become seriously tired of seeing these messages on every machine
> running an i386 Fedora kernel...
> 
> padlock: VIA PadLock not detected.
> padlock: VIA PadLock Hash Engine not detected.
> 
> So let's eliminate them!

Silly question - but why are they being printed even for older VIA
processors. We don't see the following on boot

i386: no CMOV instruction detected
i386: no SSE3 instruction detected

So I think your patch should be a bit more brutal ;)

Alan
