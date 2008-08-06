Return-Path: <linux-kernel-owner+w=401wt.eu-S1765058AbYHFJJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765058AbYHFJJ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 05:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756404AbYHFJJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 05:09:30 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51005 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754519AbYHFJJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 05:09:29 -0400
Date: Wed, 6 Aug 2008 09:51:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>
Subject: Re: Kernel Summit request for Discussion of future of ATA (libata)
 and IDE
Message-ID: <20080806095118.39035512@lxorguk.ukuu.org.uk>
In-Reply-To: <4898EE70.1030604@shaw.ca>
References: <fa.OGeO7gZvBG4obEzRbVltjSebgTQ@ifi.uio.no>
	<fa.KtvYE2B2yrJqUleolhtMPN9ljAQ@ifi.uio.no>
	<fa.AqEKTvguYFAzDFHy/We/8MpOqmo@ifi.uio.no>
	<48976168.3020804@shaw.ca>
	<20080804205508.20a3f917@lxorguk.ukuu.org.uk>
	<48977200.3050307@shaw.ca>
	<20080804220619.76b94ceb@lxorguk.ukuu.org.uk>
	<4898EE70.1030604@shaw.ca>
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

> Here's my first cut at it. Compile tested only. This sets most controllers
> to use 32-bit PIO except for those which could potentially be on a real ISA
> or other 16-bit bus. It's a bit non-obvious what to do with some of the
> drivers, so input is welcome.

Only thing I would do differently and definitely want to do differently
is the assumption that we just turn on 32bit and see what occurs. We need
to read/test/change controller by controller over to 32bit not just hope.

Alan
