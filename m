Return-Path: <linux-kernel-owner+w=401wt.eu-S1760573AbXGMNKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760573AbXGMNKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 09:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755077AbXGMNKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 09:10:23 -0400
Received: from mail-gw3.adaptec.com ([216.52.22.36]:37542 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639AbXGMNKX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 09:10:23 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: howto create partitions bigger than 2TB 
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Fri, 13 Jul 2007 09:10:19 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01BF5817@otce2k301.adaptec.com>
In-Reply-To: <4697760E.4070803@e-dict.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: howto create partitions bigger than 2TB 
Thread-Index: AcfFTWly1DinwtC9RPiIMX/iEnD1ywAAaEhg
From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
To: "Ingo Freund" <linux-kernel-news@e-dict.net>,
       <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Put a file system on the entire device, stop trying to partition it.

The standard DOS partition table is of no use to you above 2TB.

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org 
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Ingo Freund
> Sent: Friday, July 13, 2007 8:55 AM
> To: linux-kernel@vger.kernel.org
> Subject: howto create partitions bigger than 2TB 
> 
> Hi
> 
> I've got a RAID5 (driver aacraid for an ICP9047MA) with four
> 750GB hdds which provides a 2.25TB sized device.
> None of the until now used tools will work with that device.
> fdisk complains about missing cylinder count.
> cfdisk misses the device size.
> parted shows the right device size but only creates a partion
> with 51GB.
> What am I supposed to do to work with this device?
> Which fs can handle it?
> (CONFIG LARGE BLOCK is on)
> We are talking about a 32Bit machine with vanilla kernel 2.6.21.5.
> 
> Thanks in advance,
> Regards - Ingo.
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
