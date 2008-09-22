Return-Path: <linux-kernel-owner+w=401wt.eu-S1754341AbYIVXQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341AbYIVXQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 19:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbYIVXQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 19:16:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59066 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753132AbYIVXQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 19:16:15 -0400
Date: Tue, 23 Sep 2008 00:15:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: torvalds@osdl.org, linux-pcmcia@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pcmcia: Fix broken abuse of dev->driver_data
Message-ID: <20080923001534.13031535@lxorguk.ukuu.org.uk>
In-Reply-To: <20080922222655.GA3792@isilmar.linta.de>
References: <20080922155814.2bdad40f@lxorguk.ukuu.org.uk>
	<20080922215617.GA13057@comet.dominikbrodowski.net>
	<20080922231227.2625dd09@lxorguk.ukuu.org.uk>
	<20080922222655.GA3792@isilmar.linta.de>
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

> *gnah* already applied upstream, including the comment implying that PCMCIA
> driver's making use of driver_data were correct, while they were not. At
> least the trailing whitespace didn't get merged.

It was correct - dev->private_data for struct device is driver stuff, and
as the same drivers are used for pcmcia and non pcmcia its a bit hard to
argue otherwise.

Anyway tis finally sorted (and boy was it fun to pin down)

Alan
