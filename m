Return-Path: <linux-kernel-owner+w=401wt.eu-S1752921AbYKYKWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbYKYKWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 05:22:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbYKYKWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 05:22:21 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36134 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752076AbYKYKWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 05:22:21 -0500
Date: Tue, 25 Nov 2008 10:22:30 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sheng Yang <sheng@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       Sheng Yang <sheng@linux.intel.com>
Subject: Re: [PATCH] 8250: Eliminate compile warning of 8250.c
Message-ID: <20081125102230.791fa168@lxorguk.ukuu.org.uk>
In-Reply-To: <1227585503-3833-1-git-send-email-sheng@linux.intel.com>
References: <1227585320-3711-1-git-send-email-sheng@linux.intel.com>
	<1227585503-3833-1-git-send-email-sheng@linux.intel.com>
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

On Tue, 25 Nov 2008 11:58:23 +0800
Sheng Yang <sheng@linux.intel.com> wrote:

> (Something wrong with encoding of the first mail...)
> 
> The patch based on linux-2.6 upstream and elimiate this compile warning
> info:
> 
> drivers/serial/8250.c: In function 'serial8250_shutdown':
> drivers/serial/8250.c:1612: warning: 'i' may be used uninitialized in this
> function

NAK - again.

There is no real bug here and you risk hiding future ones. It also
doesn't produce a warning with a modern gcc.

Alan
