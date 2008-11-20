Return-Path: <linux-kernel-owner+w=401wt.eu-S1756060AbYKTUGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbYKTUGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 15:06:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753756AbYKTUG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 15:06:26 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53102 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753458AbYKTUGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 15:06:25 -0500
Date: Thu, 20 Nov 2008 20:06:30 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-mips@linux-mips.org, linux-serial@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       David Daney <ddaney@caviumnetworks.com>,
       Tomaso Paoletti <tpaoletti@caviumnetworks.com>
Subject: Re: [PATCH 23/26] Serial: UART driver changes for Cavium OCTEON.
Message-ID: <20081120200630.33111a2f@lxorguk.ukuu.org.uk>
In-Reply-To: <1227047057-4911-5-git-send-email-ddaney@caviumnetworks.com>
References: <49233FDE.3010404@caviumnetworks.com>
	<1227047057-4911-5-git-send-email-ddaney@caviumnetworks.com>
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

> +		if ((up->bugs & UART_BUG_OCTEON_IIR) && (iir & 0xf) == 7) {
> +			/* Busy interrupt */
> +			serial_in(up, UART_OCTEON_USR);
> +			iir = serial_in(up, UART_IIR);
> +		}

Could this not be hidden in the register read method for the octeon and
thus kept out of core code ?
