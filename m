Return-Path: <linux-kernel-owner+w=401wt.eu-S1759268AbYELLm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759268AbYELLm7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 07:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbYELLms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 07:42:48 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60768 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097AbYELLmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 07:42:47 -0400
Date: Mon, 12 May 2008 12:37:26 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Bryan Wu <cooloney@kernel.org>
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: Re: [PATCH 1/1] [PCMCIA]: add support the CF PCMCIA driver for Blackfin
Message-ID: <20080512113726.GB15305@flint.arm.linux.org.uk>
Mail-Followup-To: Bryan Wu <cooloney@kernel.org>,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
	Michael Hennerich <michael.hennerich@analog.com>
References: <1210589200-12431-1-git-send-email-cooloney@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210589200-12431-1-git-send-email-cooloney@kernel.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 06:46:40PM +0800, Bryan Wu wrote:
> +static struct device_driver bfin_cf_driver = {
> +	.name		= (char *) driver_name,
> +	.bus		= &platform_bus_type,
> +	.probe		= bfin_cf_probe,
> +	.remove		= __devexit_p(bfin_cf_remove),
> +	.suspend 	= pcmcia_socket_dev_suspend,
> +	.resume 	= pcmcia_socket_dev_resume,
> +};

NAK.  All platform device drivers must be of type 'struct platform_driver'.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
