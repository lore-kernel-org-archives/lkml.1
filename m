Return-Path: <linux-kernel-owner+w=401wt.eu-S965372AbXAYObW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965372AbXAYObW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 09:31:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965380AbXAYObW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 09:31:22 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2273 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965372AbXAYObV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 09:31:21 -0500
Date: Thu, 25 Jan 2007 14:31:12 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: "Kilau, Scott" <Scott_Kilau@digi.com>, linux-kernel@vger.kernel.org
Subject: Re: Strange problem with tty layer
Message-ID: <20070125143112.GC31145@flint.arm.linux.org.uk>
Mail-Followup-To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
	"Kilau, Scott" <Scott_Kilau@digi.com>, linux-kernel@vger.kernel.org
References: <335DD0B75189FB428E5C32680089FB9F012DCACD@mtk-sms-mail01.digi.com> <20070124213447.GB7584@csclub.uwaterloo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070124213447.GB7584@csclub.uwaterloo.ca>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 24, 2007 at 04:34:47PM -0500, Lennart Sorensen wrote:
> I am using the GPIO lines too, and didn't want to mess with the 8250
> driver (since I use that for a serial console on a 16550 UART), plus
> being able to use the 64byte fifo rather than 16byte 16550 mode fifo
> seems nicer.

Note that 8250 will use the deeper fifos if it knows how to.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
