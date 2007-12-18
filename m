Return-Path: <linux-kernel-owner+w=401wt.eu-S1755583AbXLRNdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583AbXLRNdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 08:33:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbXLRNdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 08:33:00 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:60968 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752970AbXLRNc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 08:32:59 -0500
Date: Tue, 18 Dec 2007 14:32:21 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: steve birtles <arm_kernel_development@micromark.net.cn>
Cc: "Remy Bohmer" <linux@bohmer.net>, linux-kernel@vger.kernel.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Andrew Victor <linux@maxim.org.za>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH v2] atmel_serial: Clean up the code
Message-ID: <20071218143221.790c3571@dhcp-252-066.norway.atmel.com>
In-Reply-To: <25FA62D8-BCBE-4A0E-A98D-F883FB65AFBE@micromark.net.cn>
References: <1197971591-23890-1-git-send-email-hskinnemoen@atmel.com>
	<3efb10970712180214g374749cbh940958e1eff7185c@mail.gmail.com>
	<20071218113337.061a8e59@dhcp-252-066.norway.atmel.com>
	<25FA62D8-BCBE-4A0E-A98D-F883FB65AFBE@micromark.net.cn>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Dec 2007 21:22:01 +0800
steve birtles <arm_kernel_development@micromark.net.cn> wrote:

> Is there any change can we clean this up?
>   /*
>    * We wrap our port structure around the generic uart_port.
> @@ -142,8 +146,8 @@ static void atmel_set_mctrl(struct uart_port  
> *port, u_int mctrl)
>   #ifdef CONFIG_ARCH_AT91RM9200
>   	if (cpu_is_at91rm9200()) {
>   		/*
> -		 * AT91RM9200 Errata #39: RTS0 is not internally connected to PA21.
> -		 *  We need to drive the pin manually.
> +		 * AT91RM9200 Errata #39: RTS0 is not internally connected
> +		 * to PA21. We need to drive the pin manually.
>   		 */
>   		if (port->mapbase == AT91RM9200_BASE_US0) {
>   			if (mctrl & TIOCM_RTS)
> @@ -228,7 +232,8 @@ static void atmel_stop_rx(struct uart_port *port)
>    */

I'm not sure what you mean. It just breaks the comment to fit within 80
columns...

> and potentially add those flags for  dealing with the  CTS & RTS   ,  
> that may not be used on every board,  because this clean up sit's in  
> my minor changes for the YL9200, specifically to  re-jig the USARTS  
> lines so that we can separate  RXD TXD , from a forced requirment to  
> use  control lines when using  232

Could you just post your changes so that we can see where it fits in?

Haavard
