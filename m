Return-Path: <linux-kernel-owner+w=401wt.eu-S1759782AbYD2SJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759782AbYD2SJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 14:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbYD2SJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 14:09:14 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39375 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751359AbYD2SJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 14:09:13 -0400
Date: Tue, 29 Apr 2008 19:01:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: sander@van-ginkel.eu
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptmx: adding handshake support
Message-ID: <20080429190140.1dc68904@core>
In-Reply-To: <4803C0F9.9010004@van-ginkel.eu>
References: <20080311212830.5f4apfr4uqs884cc@62.129.139.44>
	<20080330140948.0cqmtqb9us880cw8@62.129.139.44>
	<20080330131652.7073589c@core>
	<480229CB.2080108@van-ginkel.eu>
	<20080413233503.22576c47@core>
	<4803C0F9.9010004@van-ginkel.eu>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008 22:39:21 +0200
sander van ginkel <sander@van-ginkel.eu> wrote:

> Corrected the last issues
> 
> Signed-off-by: Sander van Ginkel <sander@van-ginkel.eu>

NAK

Having played with this (and fixed up further issues) it simply doesn't
work in the real world. pty/tty pairs are always 8bit, don't support
CREAD and can't pass break signals, emulate multiple flow control types
or parity.

A virtual serial device is still a good idea, but a quick hack on pty
devices doesn't actually work - the problem is far more complicated.

Alan
