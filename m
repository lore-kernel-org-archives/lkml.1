Return-Path: <linux-kernel-owner+w=401wt.eu-S1756338AbYGTC1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338AbYGTC1w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 22:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755232AbYGTC1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 22:27:43 -0400
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:60785 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201AbYGTC1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 22:27:42 -0400
Date: Sat, 19 Jul 2008 22:27:40 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Joel Soete <soete.joel@scarlet.be>
Cc: Kyle McMartin <kyle@mcmartin.ca>, linux-parisc@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ccio_clear_io_tlb() don't need to compute io page
	number a second time.
Message-ID: <20080720022740.GA6427@phobos.i.cabal.ca>
References: <48825DD0.5000308@scarlet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48825DD0.5000308@scarlet.be>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2008 at 09:34:08PM +0000, Joel Soete wrote:
> --- a/drivers/parisc/ccio-dma.c	2008-07-19 21:17:37.000000000 +0000
> +++ b/drivers/parisc/ccio-dma.c	2008-07-19 21:32:54.000000000 +0000
> @@ -643,7 +643,6 @@
>  {
>  	u32 chain_size = 1 << ioc->chainid_shift;
>
> -	iovp &= IOVP_MASK;	/* clear offset bits, just want pagenum */
>  	byte_cnt += chain_size;
>
>  	while(byte_cnt > chain_size) {

applied.
