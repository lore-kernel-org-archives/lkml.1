Return-Path: <linux-kernel-owner+w=401wt.eu-S934562AbXHMXCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934562AbXHMXCw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 19:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479AbXHMXCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 19:02:42 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55520 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750932AbXHMXCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 19:02:41 -0400
Date: Tue, 14 Aug 2007 00:09:56 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: hinoue@ccsl.carleton.ca
Cc: linux-kernel@vger.kernel.org
Subject: Re: System call interposition/unprotecting the table
Message-ID: <20070814000956.7c8929dd@the-village.bc.nu>
In-Reply-To: <20070813180535.vo36rcevi80s0c4c@www.ccsl.carleton.ca>
References: <20070813180535.vo36rcevi80s0c4c@www.ccsl.carleton.ca>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2007 18:05:35 -0400
hinoue@ccsl.carleton.ca wrote:

> I have a question about changing the page attributes of the
> system call table.

Please don't do that.

> This works fine on my debian system, but apparently the stock Fedora
> kernel (2.6.22) has the system call table write protected.  

This is to protect it from being changed by an attacker or someone trying
to do strange and bogus things to the kernel.

What are you actually trying to achieve ?
