Return-Path: <linux-kernel-owner+w=401wt.eu-S1754769AbYG2Xhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbYG2Xhk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 19:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbYG2Xhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 19:37:31 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33348 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752040AbYG2Xha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 19:37:30 -0400
Date: Wed, 30 Jul 2008 00:20:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Tvrtko A. Ursulin" <tvrtko@ursulin.net>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: 2.6.26 DVD playing regression with libata
Message-ID: <20080730002011.21947c32@lxorguk.ukuu.org.uk>
In-Reply-To: <200807292323.28033.tvrtko@ursulin.net>
References: <200807292323.28033.tvrtko@ursulin.net>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Jul 29 21:10:03 media kernel: [353032.319013] sr 2:0:0:0: [sr0] unaligned transfer
> Jul 29 21:10:03 media kernel: [353032.319013] sr 2:0:0:0: [sr0] unaligned transfer

This is coming from the scsi/block layer and definitely isn't good.
Doesn't directly look like a libata bug but seems to be higher up the
stack. What software is triggering this ?
