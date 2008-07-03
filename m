Return-Path: <linux-kernel-owner+w=401wt.eu-S1754352AbYGCQzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352AbYGCQzh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 12:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbYGCQz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 12:55:29 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48931 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225AbYGCQz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 12:55:28 -0400
Date: Thu, 3 Jul 2008 17:55:05 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sedji Gaouaou <sedji.gaouaou@atmel.com>
Cc: VILCHEZ Patrice <Patrice.VILCHEZ@atmel.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Support for the at91sam9g20 : Atmel 400Mhz ARM 926ej-s SOC
Message-ID: <20080703165505.GT17201@flint.arm.linux.org.uk>
References: <4852324C.9000604@atmel.com> <20080703133244.GB17201@flint.arm.linux.org.uk> <486CDFE5.9030105@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486CDFE5.9030105@atmel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2008 at 04:19:17PM +0200, Sedji Gaouaou wrote:
> Hi Andrew,
> >   
> >> +/*
> >> + * MCI (SD/MMC)
> >> + */
> >> +static struct at91_mmc_data __initdata ek_mmc_data = {
> >> +	.slot_b		= 1,
> >> +	.wire4		= 1,
> >> +//	.det_pin	= ... not connected
> >> +//	.wp_pin		= ... not connected
> >> +//	.vcc_pin	= ... not connected
> >>     
> >
> > Please make these a proper comment, preferably inside the comment before
> > the structure.  C++ comments are frowned upon in the kernel's source.
>
>
> I would like to know what do you suggest about this comment? Indeed we 
> already use this kind of comments, for instance in board-sam9260ek.c. I 
> don't mind changing it into the proper comment form, but I would like to 
> know first what do you suggest.

Documentation/CodingStyle:
|
|                Chapter 8: Commenting
|
...
|
|Linux style for comments is the C89 "/* ... */" style.
|Don't use C99-style "// ..." comments.

So how about:

/*
 * MCI (SD/MMC)
 * det_pin, wp_pin and vcc_pin are not connected
 */
static struct at91_mmc_data __initdata ek_mmc_data = {
	.slot_b         = 1,
	.wire4          = 1,
};
