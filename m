Return-Path: <linux-kernel-owner+w=401wt.eu-S1422693AbXBURJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422693AbXBURJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 12:09:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422712AbXBURJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 12:09:58 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39712 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422710AbXBURJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 12:09:57 -0500
Date: Wed, 21 Feb 2007 18:11:28 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       ralf@linux-mips.org
Subject: Re: [PATCH 2.6.21-rc1] serial: serial_txx9 driver update
Message-ID: <20070221181128.3a19d66c@lxorguk.ukuu.org.uk>
In-Reply-To: <20070222.020242.51866797.anemo@mba.ocn.ne.jp>
References: <20070222.003142.106263613.anemo@mba.ocn.ne.jp>
	<20070221164826.61d0b5ea@lxorguk.ukuu.org.uk>
	<20070222.020242.51866797.anemo@mba.ocn.ne.jp>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Then I'll put udelay() and a timeout counter for it.  If udelay() was
> in the busy loop, cpu_relax() is still recommended?

The udelay should deal with it for you.
 
> Here is a patch on top of the previous one.  If this was OK I'll fold
> it into one patch.

Looks good to me

> +	while ((sio_in(up, TXX9_SIFCR) & TXX9_SIFCR_SWRST) && --tmout)
> +		udelay(1);
>  	/* TX Int by FIFO Empty, RX Int by Receiving 1 char. */
>  	sio_set(up, TXX9_SIFCR,
>  		TXX9_SIFCR_TDIL_MAX | TXX9_SIFCR_RDIL_1);


-- 
--
Sick of rip off UK rail fares ? Learn how to get far cheaper fares
		http://zeniv.linux.org.uk/~alan/GTR/
