Return-Path: <linux-kernel-owner+w=401wt.eu-S1762866AbZDAJO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762866AbZDAJO0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 05:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760120AbZDAJOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 05:14:15 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40528 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756058AbZDAJOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 05:14:14 -0400
Date: Wed, 1 Apr 2009 10:13:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Andrew Victor <linux@maxim.org.za>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       Peter Ma <pma@mediamatech.com>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH 2/2] avr32: add hardware handshake support to
 atmel_serial
Message-ID: <20090401101348.2293308d@lxorguk.ukuu.org.uk>
In-Reply-To: <1238576038-8915-2-git-send-email-haavard.skinnemoen@atmel.com>
References: <1238576038-8915-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1238576038-8915-2-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  1 Apr 2009 10:53:58 +0200
Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:

> From: Peter Ma <pma@mediamatech.com>
> 
> Adds Hardware Handshake (aka RTS/CTS flow-control) support to
> atmel_serial driver, as a termios flag.
> 
> For this to actually work, the platform code needs to configure the RTS
> and CTS pins for use by the USART. This has been done for AVR32 as a
> separate patch.

Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>

Looks fine to me from the tty side. I assume it will go via the atmel
tree to keep the patches together nicely ?
