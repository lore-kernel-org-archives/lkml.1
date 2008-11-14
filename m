Return-Path: <linux-kernel-owner+w=401wt.eu-S1755300AbYKNVrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbYKNVrZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 16:47:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbYKNVrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 16:47:17 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58059 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751204AbYKNVrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 16:47:16 -0500
Date: Fri, 14 Nov 2008 21:47:11 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "George Spelvin" <linux@horizon.com>
Cc: linux-kernel@vger.kernel.org, linux@horizon.com
Subject: Re: [RFC 2/2] serial/8250.c: Use self-adjusting list for port poll
 order.
Message-ID: <20081114214711.3c1d1473@lxorguk.ukuu.org.uk>
In-Reply-To: <20081114213449.14960.qmail@science.horizon.com>
References: <20081113150308.3590.qmail@science.horizon.com>
	<20081114053042.11532.qmail@science.horizon.com>
	<20081114053314.12093.qmail@science.horizon.com>
	<20081114213449.14960.qmail@science.horizon.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This code does that by using the previous poll cycles as a hint.
> If a port is idle, it will migrate to the end of the list and
> only have to be checked once.
> 
> Part 1 changed the list to singly-linked to make the list shuffling easier.
> 
> Comments?  Please?

Is it really worth the complexity

- PCI ports are shared IRQ always
- Legacy ports are almost never shared IRQ on the LPC bus (and are
increasingly going away)

