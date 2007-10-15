Return-Path: <linux-kernel-owner+w=401wt.eu-S1758376AbXJOWF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758376AbXJOWF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 18:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763022AbXJOWFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 18:05:00 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:3306 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760077AbXJOWE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 18:04:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PdHmHbPClqktu78ubn7qi31Q/f7ndG4h9oekA4pbBcu0nKxZ1XTOYECT7uKUlBlBLj+hBWnMneGp0pASqXdwgH+XGZ2+hlsci/DXdpnFEpMJ0mo56iK1tby4w7Bx+KXCu3Lh34KjxYVJT+o04O9xnDT1+E39qU9YdwHlqJcYpW4=
Message-ID: <8bd0f97a0710151504s4faa480due0d54f30a21a7704@mail.gmail.com>
Date: Mon, 15 Oct 2007 18:04:57 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Bryan Wu" <bryan.wu@analog.com>
Subject: Re: [PATCH 3/3] Blackfin serial driver: this driver enable SPORTs on Blackfin emulate UART
Cc: dmitry.torokhov@gmail.com, linux-input@atrey.karlin.mff.cuni.cz,
       linux-joystick@atrey.karlin.mff.cuni.cz, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <1192098220-25828-4-git-send-email-bryan.wu@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1192098220-25828-1-git-send-email-bryan.wu@analog.com>
	 <1192098220-25828-4-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/07, Bryan Wu <bryan.wu@analog.com> wrote:
> --- a/drivers/serial/Kconfig
> +++ b/drivers/serial/Kconfig
> +config SERIAL_BFIN_SPORT
> +       tristate "Blackfin SPORT emulate UART (EXPERIMENTAL)"
> +       depends on BFIN && EXPERIMENTAL
> +       select SERIAL_CORE
> +       help
> +         Enble support SPORT emulate UART on Blackfin series.
> +
> +         To compile this driver as a module, choose M here: the
> +         module will be called bfin_sport_uart.
> +
> +choice
> +       prompt "Baud rate for Blackfin SPORT UART"
> +       depends on SERIAL_BFIN_SPORT
> +       default SERIAL_SPORT_BAUD_RATE_57600
> +       help
> +         Choose a baud rate for the SPORT UART, other uart settings are
> +         8 bit, 1 stop bit, no parity, no flow control.

this looks wrong to me ... why cant the standard infrastructure for
managing baud rate be used ?
-mike
