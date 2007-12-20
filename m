Return-Path: <linux-kernel-owner+w=401wt.eu-S1756255AbXLTVqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255AbXLTVqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 16:46:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752739AbXLTVqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 16:46:35 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52677 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752656AbXLTVqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 16:46:33 -0500
Date: Thu, 20 Dec 2007 21:39:19 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Will Newton" <will.newton@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH] Support specifying DW APB UARTSs in device
 platform_data
Message-ID: <20071220213919.79ff17f1@the-village.bc.nu>
In-Reply-To: <87a5b0800712200648o7cc48af9ic38d7d568affdbc8@mail.gmail.com>
References: <87a5b0800712200648o7cc48af9ic38d7d568affdbc8@mail.gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2007 14:48:45 +0000
"Will Newton" <will.newton@gmail.com> wrote:

> This patch allows the private_data field to be specified in
> platform_data for the standard 8250/16550 UART. This field is used by
> DW APB type UARTs and without this patch it's only possible to set
> this field when registering the port by hand. If private_data is not
> set then the
> driver will potentially oops with a NULL pointer dereference.


Fine by me. 

Alan
