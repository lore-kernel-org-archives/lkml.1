Return-Path: <linux-kernel-owner+w=401wt.eu-S1758363AbYBMWB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758363AbYBMWB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 17:01:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933941AbYBMVrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:47:15 -0500
Received: from mx.neterion.com ([72.1.205.142]:11823 "EHLO owa.neterion.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933936AbYBMVrM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:47:12 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [2.6 patch] make s2io.c:init_tti() static
Date: Wed, 13 Feb 2008 16:45:08 -0500
Message-ID: <78C9135A3D2ECE4B8162EBDCE82CAD770305B135@nekter>
In-Reply-To: <20080213213050.GN3383@cs181133002.pp.htv.fi>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [2.6 patch] make s2io.c:init_tti() static
Thread-Index: Achuh9PR6MKuzqfpQMq8oN8hJcc9dQAAbrFA
References: <20080213213050.GN3383@cs181133002.pp.htv.fi>
From: "Ramkrishna Vepa" <Ramkrishna.Vepa@neterion.com>
To: "Jeff Garzik" <jeff@garzik.org>
Cc: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       "Adrian Bunk" <bunk@kernel.org>,
       "Surjit Reang" <Surjit.Reang@neterion.com>,
       "Sreenivasa Honnur" <Sreenivasa.Honnur@neterion.com>,
       "Ramkrishna Vepa" <ram.vepa@neterion.com>,
       "Rastapur Santosh" <santosh.rastapur@neterion.com>,
       "Sivakumar Subramani" <Sivakumar.Subramani@neterion.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please apply. Looks good.

Ram

> -----Original Message-----
> From: Adrian Bunk [mailto:bunk@kernel.org]
> Sent: Wednesday, February 13, 2008 1:31 PM
> To: Surjit Reang; Sreenivasa Honnur; Ramkrishna Vepa; Rastapur
Santosh;
> Sivakumar Subramani
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [2.6 patch] make s2io.c:init_tti() static
> 
> This patch makes the needlessly global init_tti() static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
> This patch has been sent on:
> - 30 Jan 2008
> 
> 1e8c2b07be955b181814e4c24366517a66557908
> diff --git a/drivers/net/s2io.c b/drivers/net/s2io.c
> index 5fab7d7..bc94e84 100644
> --- a/drivers/net/s2io.c
> +++ b/drivers/net/s2io.c
> @@ -1088,7 +1088,7 @@ static int s2io_print_pci_mode(struct s2io_nic
*nic)
>   *  '-1' on failure
>   */
> 
> -int init_tti(struct s2io_nic *nic, int link)
> +static int init_tti(struct s2io_nic *nic, int link)
>  {
>  	struct XENA_dev_config __iomem *bar0 = nic->bar0;
>  	register u64 val64 = 0;

