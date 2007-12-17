Return-Path: <linux-kernel-owner+w=401wt.eu-S936152AbXLQQVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936152AbXLQQVW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 11:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935929AbXLQQUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 11:20:44 -0500
Received: from dspnet.fr.eu.org ([213.186.44.138]:2820 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935011AbXLQQUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 11:20:43 -0500
Date: Mon, 17 Dec 2007 17:20:40 +0100
From: Olivier Galibert <galibert@pobox.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Filippos Papadopoulos <psybases@gmail.com>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: INITIO scsi driver fails to work properly
Message-ID: <20071217162040.GB5056@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Boaz Harrosh <bharrosh@panasas.com>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Filippos Papadopoulos <psybases@gmail.com>,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <9f00bd9d0712170139q1397af5fp3c855a2b94726227@mail.gmail.com> <20071217031841.f483e5ac.akpm@linux-foundation.org> <20071217130523.7e9c88bb@the-village.bc.nu> <47668A75.7040707@panasas.com> <20071217143641.760d4162@the-village.bc.nu> <1197903781.3204.4.camel@localhost.localdomain> <47669F1B.4090400@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47669F1B.4090400@panasas.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2007 at 06:08:59PM +0200, Boaz Harrosh wrote:
> Below fixes a deadly typo. Might as well be included in 2.6.24

You're sure ?  scsi_for_each_sg includes a (sg)++ already...


>  		scsi_for_each_sg(cmnd, sglist, cblk->sglen, i) {
>  			sg->data = cpu_to_le32((u32)sg_dma_address(sglist));
>  			total_len += sg->len = cpu_to_le32((u32)sg_dma_len(sglist));
> +			++sg;
>  		}

  OG.
