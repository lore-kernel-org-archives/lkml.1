Return-Path: <linux-kernel-owner+w=401wt.eu-S1758733AbXLLJR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733AbXLLJR0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 04:17:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757283AbXLLJRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 04:17:13 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49608 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756601AbXLLJRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 04:17:11 -0500
Date: Wed, 12 Dec 2007 01:16:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: chripell@gmail.com
Cc: linux-kernel@vger.kernel.org, Christian Pellegrin <chripell@fsfe.org>,
       Thomas Richter <thor@math.TU-Berlin.DE>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Martin Schitter <ms@gewi.kfunigraz.ac.at>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [PATCH] netmos 9855 fix
Message-Id: <20071212011625.598654e9.akpm@linux-foundation.org>
In-Reply-To: <11968504473036-git-send-email-chripell@gmail.com>
References: <11968504473036-git-send-email-chripell@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  5 Dec 2007 11:27:27 +0100 chripell@gmail.com wrote:

> Fixes wrong netmos 9855 serial port configuration.
> 
> Generated on  20071205  against v2.6.21
> 
> Signed-off-by: Christian Pellegrin <chripell@fsfe.org>
> ---
>  drivers/parport/parport_serial.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/parport/parport_serial.c b/drivers/parport/parport_serial.c
> index 78c0a26..5b04e78 100644
> --- a/drivers/parport/parport_serial.c
> +++ b/drivers/parport/parport_serial.c
> @@ -77,7 +77,7 @@ static struct parport_pc_pci cards[] __devinitdata = {
>  	/* titan_110l */		{ 1, { { 3, -1 }, } },
>  	/* titan_210l */		{ 1, { { 3, -1 }, } },
>  	/* netmos_9xx5_combo */		{ 1, { { 2, -1 }, }, netmos_parallel_init },
> -	/* netmos_9855 */		{ 1, { { 0, -1 }, }, netmos_parallel_init },
> +	/* netmos_9855 */		{ 1, { { 2, -1 }, }, netmos_parallel_init },
>  	/* avlab_1s1p     */		{ 1, { { 1, 2}, } },
>  	/* avlab_1s2p     */		{ 2, { { 1, 2}, { 3, 4 },} },
>  	/* avlab_2s1p     */		{ 1, { { 2, 3}, } },
> @@ -185,7 +185,7 @@ static struct pciserial_board pci_parport_serial_boards[] __devinitdata = {
>  		.uart_offset	= 8,
>  	},
>  	[netmos_9855] = {
> -		.flags		= FL_BASE2 | FL_BASE_BARS,
> +		.flags		= FL_BASE4 | FL_BASE_BARS,
>  		.num_ports	= 1,
>  		.base_baud	= 115200,
>  		.uart_offset	= 8,

What was wrong with it?

Martin, does this change affect the hardware upon which you tested
44e58a6a0bd604f46be9d808408a1cd880cc9b19, "parport: NetMos nm9855 fix"?

Thanks.
