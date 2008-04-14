Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbYDNUEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbYDNUEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 16:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750919AbYDNUEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 16:04:45 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:34332 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbYDNUEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 16:04:44 -0400
Date: Mon, 14 Apr 2008 13:02:41 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: sander@van-ginkel.eu
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptmx: adding handshake support
Message-Id: <20080414130241.f54fa128.randy.dunlap@oracle.com>
In-Reply-To: <4803C0F9.9010004@van-ginkel.eu>
References: <20080311212830.5f4apfr4uqs884cc@62.129.139.44>
	<20080330140948.0cqmtqb9us880cw8@62.129.139.44>
	<20080330131652.7073589c@core>
	<480229CB.2080108@van-ginkel.eu>
	<20080413233503.22576c47@core>
	<4803C0F9.9010004@van-ginkel.eu>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008 22:39:21 +0200 sander van ginkel wrote:

> Corrected the last issues

Not AFAICT.  There's no full changelog/description here...
and see below.


> Signed-off-by: Sander van Ginkel <sander@van-ginkel.eu>
> 
> ===================================================================
> 
> diff -pru linux-2.6.25-rc8.orig/drivers/char/pty.c 
> linux-2.6.25-rc8/drivers/char/pty.c
> --- linux-2.6.25-rc8.orig/drivers/char/pty.c    2008-04-01 
> 21:44:26.000000000 +0200
> +++ linux-2.6.25-rc8/drivers/char/pty.c    2008-04-14 23:01:56.000000000 
> +0200
> @@ -196,6 +196,7 @@ static void pty_flush_buffer(struct tty_
>  
>  static int pty_open(struct tty_struct *tty, struct file * filp)
>  {
> +    unsigned int    *mcrmsr;

Something converted tabs to spaces throughout the entire patch.


>      int    retval = -ENODEV;
>  
>      if (!tty || !tty->link)

---
~Randy
