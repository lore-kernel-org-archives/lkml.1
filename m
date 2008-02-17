Return-Path: <linux-kernel-owner+w=401wt.eu-S1756644AbYBQWdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644AbYBQWdo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 17:33:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbYBQWde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 17:33:34 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50281 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753927AbYBQWdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 17:33:33 -0500
Date: Sun, 17 Feb 2008 22:24:40 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "David P. Reed" <dpreed@reed.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       "David P. Reed" <dpreed@reed.com>
Subject: Re: [PATCH 2/3] x86: fix cmos read and write to not use inb_p and
 outb_p
Message-ID: <20080217222440.32aeb055@core>
In-Reply-To: <6gr00g$g7cm9p@smtp01.lnh.mail.rcn.net>
References: <6gr00g$g7cm9p@smtp01.lnh.mail.rcn.net>
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

On Sun, 17 Feb 2008 16:56:39 -0500 (EST)
"David P. Reed" <dpreed@reed.com> wrote:

> fix code to access CMOS rtc registers so that it does not use inb_p and
> outb_p routines, which are deprecated.

> Signed-off-by: David P. Reed <dpreed@reed.com>

Acked-by: Alan Cox <alan@redhat.com>

It is remotely possible that we will find we need the delays eventually,
but if we do the lot is localised into two methods so its easy to change
and this should be safe anyway.
