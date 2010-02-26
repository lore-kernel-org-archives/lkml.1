Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935630Ab0BZJGL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 04:06:11 -0500
Received: from symlink.to.noone.org ([85.10.207.172]:59967 "EHLO sym.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935584Ab0BZJGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 04:06:07 -0500
Date: Fri, 26 Feb 2010 10:06:04 +0100
From: Tobias Klauser <tklauser@distanz.ch>
To: Peter Korsgaard <jacmet@sunsite.dk>
Cc: linux-serial@vger.kernel.org, nios2-dev@sopc.et.ntust.edu.tw,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] serial: Add driver for the Altera JTAG UART
Message-ID: <20100226090604.GB32296@distanz.ch>
References: <1267108523-32767-1-git-send-email-tklauser@distanz.ch> <87ocjd5knm.fsf@macbook.be.48ers.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ocjd5knm.fsf@macbook.be.48ers.dk>
X-Editor: Vi IMproved 7.1
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-02-25 at 17:45:33 +0100, Peter Korsgaard <jacmet@sunsite.dk> wrote:
> >>>>> "Tobias" == Tobias Klauser <tklauser@distanz.ch> writes:
> 
>  Tobias> Add an UART driver for the JTAG UART component available as a SOPC
>  Tobias> (System on Programmable Chip) component for Altera FPGAs.
> 
>  Tobias> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
>  
>  Tobias> +config SERIAL_ALTERA_JTAGUART
>  Tobias> +	bool "Altera JTAG UART support"
>  Tobias> +	depends on EMBEDDED
> 
> Don't depend on EMBEDDED - There's embedded devices not using
> CONFIG_EMBEDDED and kernel configs for PCs using it.

I'll remove the dependency for bot altera_jtaguart and altera_uart.

Thanks a lot,
Tobias
