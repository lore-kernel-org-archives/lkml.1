Return-Path: <linux-kernel-owner+w=401wt.eu-S1754767AbYJNWx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbYJNWx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 18:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752333AbYJNWxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 18:53:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38692 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752256AbYJNWxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 18:53:21 -0400
Date: Tue, 14 Oct 2008 23:53:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: donald.d.dugger@intel.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Enable console on PCI serial devices
Message-ID: <20081014235317.398c0a1a@lxorguk.ukuu.org.uk>
In-Reply-To: <200810142231.m9EMV95O002974@los-vmm.sc.intel.com>
References: <200810142231.m9EMV95O002974@los-vmm.sc.intel.com>
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

> F is the flow control, III is the I/O port address (prefix with 0x for
> hexadecimal) and CCC is the crystal frequency.  -III and /CCC are optional
> and can be omitted although -III must be specified if you want to set
> /CCC.  For example, the option I use is:

I am sure real men would compute the equivalent baud rate for the clock by
hand ;) This looks a sensible patch, will queue.

Now I wonder if uart_parse_options can be __init 

Alan
