Return-Path: <linux-kernel-owner+w=401wt.eu-S1754748AbZFHIkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbZFHIkU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 04:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbZFHIkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 04:40:07 -0400
Received: from relay.atmel.no ([80.232.32.139]:56092 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799AbZFHIkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 04:40:06 -0400
Date: Mon, 8 Jun 2009 10:39:23 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: "Eirik Aanonsen" <eaa@wprmedical.com>
Cc: Nicolas Ferre <Nicolas.FERRE@atmel.com>,
       Andrew Victor <avictor.za@gmail.com>, kernel@avr32linux.org,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] atmel_serial: Fix hang in set_termios when crtscts is
 enabled
Message-ID: <20090608103923.055eb888@hskinnemoen-d830>
In-Reply-To: <1DC0FF5051B91B4D88A15F21F1A27F4176AE6A@dware1013.doorway.loc>
References: <1244448921-22942-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1DC0FF5051B91B4D88A15F21F1A27F4176AE6A@dware1013.doorway.loc>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eirik Aanonsen wrote:
> Works like a charm :) Thanx. I sis not use the patch but I just 
> Added a 0& inside the condition to the while loop.

Thanks for testing. I did a quick test on my NGW as well (using a UART
which isn't actually hooked up to anything) and I couldn't get it to
hang with the patch applied.

Haavard
