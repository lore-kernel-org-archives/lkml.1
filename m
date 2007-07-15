Return-Path: <linux-kernel-owner+w=401wt.eu-S1761347AbXGOXYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761347AbXGOXYU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 19:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755114AbXGOXYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 19:24:12 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45039 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439AbXGOXYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 19:24:11 -0400
Date: Mon, 16 Jul 2007 00:24:10 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Yoshihiro Shimoda <shimoda.yoshihiro@renesas.com>
Subject: Re: [PATCH] minimal fixes for drivers/usb/gadget/m66592-udc.c
Message-ID: <20070715232410.GH21668@ftp.linux.org.uk>
References: <200707151607.20275.david-b@pacbell.net> <200707151618.10688.david-b@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707151618.10688.david-b@pacbell.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 15, 2007 at 04:18:10PM -0700, David Brownell wrote:
> Re the leaks, in probe() request_irq() isn't cleaned up ... but it
> looked to me like the rest of the allocations did get cleaned up
> afer probe() errors.  But remove() does indeed leak the memory you
> highlighted.

Why not make ep0_buf a 16bit field in that struct?
