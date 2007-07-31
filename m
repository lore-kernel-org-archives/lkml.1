Return-Path: <linux-kernel-owner+w=401wt.eu-S932439AbXGaRrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439AbXGaRrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 13:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754376AbXGaRrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 13:47:06 -0400
Received: from mail-gw3.adaptec.com ([216.52.22.36]:52666 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947AbXGaRrE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 13:47:04 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 21] drivers/scsi/dpt_i2o.c: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 13:45:23 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01CB7477@otce2k301.adaptec.com>
In-Reply-To: <200707311935.13958.m.kozlowski@tuxland.pl>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 21] drivers/scsi/dpt_i2o.c: kmalloc + memset conversion to kzalloc
Thread-Index: AcfTmSmYUlcO7jneTUuFdqUbpmnHqAAAUrKw
From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
To: "Mariusz Kozlowski" <m.kozlowski@tuxland.pl>,
       <linux-kernel@vger.kernel.org>
Cc: <kernel-janitors@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-scsi@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ACK

Looks good and ultra-light on side effects!

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: Mariusz Kozlowski [mailto:m.kozlowski@tuxland.pl] 
> Sent: Tuesday, July 31, 2007 1:35 PM
> To: linux-kernel@vger.kernel.org
> Cc: kernel-janitors@vger.kernel.org; Andrew Morton; 
> linux-scsi@vger.kernel.org; AACRAID
> Subject: [PATCH 21] drivers/scsi/dpt_i2o.c: kmalloc + memset 
> conversion to kzalloc
> 
> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> 
>  drivers/scsi/dpt_i2o.c | 87632 -> 87457 (-175 bytes)
>  drivers/scsi/dpt_i2o.o | 213064 -> 212324 (-740 bytes)
> 
>  drivers/scsi/dpt_i2o.c |   27 +++++++++++----------------
>  1 file changed, 11 insertions(+), 16 deletions(-)
