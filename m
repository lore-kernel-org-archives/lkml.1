Return-Path: <linux-kernel-owner+w=401wt.eu-S932260AbYGRBSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260AbYGRBSB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 21:18:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753874AbYGRBRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 21:17:53 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:24552 "EHLO
	pd7mo1no-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751582AbYGRBRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 21:17:52 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=XTumNCo9Hso2kLmFqZ8A:9 a=pZ3vLOD9iVBoOe8JrsiNGUxx7YoA:4 a=vqnd-49lz8MA:10 a=IEDKYtWOwmAA:10
Message-ID: <487FEF3D.3060709@shaw.ca>
Date: Thu, 17 Jul 2008 19:17:49 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, trelane@digitasaru.net
Subject: Re: ata error message exception Emask 0x0 SAct 0x0 SErr 0x0 action
 0x2
References: <fa.nKgr6Ih9+hsUpOTCrIh8muNF7MY@ifi.uio.no>
In-Reply-To: <fa.nKgr6Ih9+hsUpOTCrIh8muNF7MY@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joseph Pingenot wrote:
> Hi all.
> 
> Anyone know what is causing the following troubles:
> Jul 16 16:16:27 cruftix kernel: [12538.998440] ata5.00: exception Emask
> 0x0 SAct 0x0 SErr 0x0 action 0x2
> Jul 16 16:16:27 cruftix kernel: [12538.998450] ata5.00: irq_stat
> 0x00020002, device error via D2H FIS
> Jul 16 16:16:27 cruftix kernel: [12538.998457] ata5.00: cmd
> 35/00:08:87:17:58/00:00:59:00:00/e0 tag 0 dma 4096 out
> Jul 16 16:16:27 cruftix kernel: [12538.998459]          res
> 51/84:00:8e:17:58/00:00:59:00:00/e0 Emask 0x10 (ATA bus error)
> Jul 16 16:16:27 cruftix kernel: [12538.998464] ata5.00: status: { DRDY
> ERR }
> Jul 16 16:16:27 cruftix kernel: [12538.998466] ata5.00: error: { ICRC
> ABRT }

..

> (just a sampling)
> I'm transferring data to an ext3 filesystem on a Seagate FreeAgent Pro
>   1TB disk with an eSATA connector (Norco 4618 eSATA card with SiI 3124:

Looks like you're getting errors on the SATA link. It sounds like a lot 
of eSATA cables are crap and don't connect properly, etc. so that would 
be the first thing to try swapping out.
