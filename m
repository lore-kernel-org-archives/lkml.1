Return-Path: <linux-kernel-owner+w=401wt.eu-S1756058AbZDAJWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbZDAJWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 05:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbZDAJWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 05:22:20 -0400
Received: from relay.atmel.no ([80.232.32.139]:64101 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599AbZDAJWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 05:22:20 -0400
Date: Wed, 1 Apr 2009 11:21:53 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: lkml <linux-kernel@vger.kernel.org>, Andrew Victor <linux@maxim.org.za>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       Peter Ma <pma@mediamatech.com>
Subject: Re: [PATCH 2/2] avr32: add hardware handshake support to
 atmel_serial
Message-ID: <20090401112153.093b27c7@hskinnemoen-d830>
In-Reply-To: <20090401101348.2293308d@lxorguk.ukuu.org.uk>
References: <1238576038-8915-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1238576038-8915-2-git-send-email-haavard.skinnemoen@atmel.com>
	<20090401101348.2293308d@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Wed,  1 Apr 2009 10:53:58 +0200
> Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:
> 
> > From: Peter Ma <pma@mediamatech.com>
> > 
> > Adds Hardware Handshake (aka RTS/CTS flow-control) support to
> > atmel_serial driver, as a termios flag.
> > 
> > For this to actually work, the platform code needs to configure the RTS
> > and CTS pins for use by the USART. This has been done for AVR32 as a
> > separate patch.  
> 
> Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
> 
> Looks fine to me from the tty side. I assume it will go via the atmel
> tree to keep the patches together nicely ?

Thanks. I'll merge both through the avr32 tree.

Haavard
