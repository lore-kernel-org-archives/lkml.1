Return-Path: <linux-kernel-owner+w=401wt.eu-S1757766AbYBRPzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757766AbYBRPzJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 10:55:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708AbYBRPy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 10:54:57 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55262 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753208AbYBRPy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 10:54:57 -0500
Date: Mon, 18 Feb 2008 15:45:46 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "David P. Reed" <dpreed@reed.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       "David P. Reed" <dpreed@reed.com>
Subject: Re: [patch 1/2] x86: define outb_pic and inb_pic to stop using
 outb_p and inb_p
Message-ID: <20080218154546.66e4c72d@core>
In-Reply-To: <6gr00g$g7mc5k@smtp01.lnh.mail.rcn.net>
References: <6gr00g$g7mc5k@smtp01.lnh.mail.rcn.net>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +unsigned char inb_pic(unsigned int port)
> +{
> +	/* delay for some accesses to PIC on motherboard or in chipset must be
> +	   at least one microsecond, but be safe here. */
> +	unsigned char value = inb(port);
> +	udelay(2);
> +	return value;
> +}

inline it. Its almost no instructions
