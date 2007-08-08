Return-Path: <linux-kernel-owner+w=401wt.eu-S936954AbXHHQfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936954AbXHHQfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 12:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936388AbXHHQfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 12:35:07 -0400
Received: from mx.neterion.com ([72.1.205.142]:13537 "EHLO owa.neterion.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936949AbXHHQfE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 12:35:04 -0400
X-Greylist: delayed 893 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Aug 2007 12:35:03 EDT
X-MIMEOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 68] drivers/net/s2io.c: kmalloc + memset conversion to k[cz]alloc
Date: Wed, 8 Aug 2007 12:16:36 -0400
Message-ID: <78C9135A3D2ECE4B8162EBDCE82CAD77020354C0@nekter>
In-Reply-To: <46B8EAD0.2040303@pobox.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 68] drivers/net/s2io.c: kmalloc + memset conversion to k[cz]alloc
Thread-Index: AcfZPpvRdgj7YChPSfy6Tn0NVud4wQAmI/UA
From: "Ramkrishna Vepa" <Ramkrishna.Vepa@neterion.com>
To: "Jeff Garzik" <jgarzik@pobox.com>,
       "Mariusz Kozlowski" <m.kozlowski@tuxland.pl>
Cc: <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, <netdev@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We have a few patches queued and can send this patch in along with ours.

Ram

> -----Original Message-----
> From: netdev-owner@vger.kernel.org
[mailto:netdev-owner@vger.kernel.org]
> On Behalf Of Jeff Garzik
> Sent: Tuesday, August 07, 2007 2:58 PM
> To: Mariusz Kozlowski
> Cc: linux-kernel@vger.kernel.org; kernel-janitors@vger.kernel.org;
Andrew
> Morton; netdev@vger.kernel.org
> Subject: Re: [PATCH 68] drivers/net/s2io.c: kmalloc + memset
conversion to
> k[cz]alloc
> 
> Mariusz Kozlowski wrote:
> > Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> >
> >  drivers/net/s2io.c | 235587 -> 235340 (-247 bytes)
> >  drivers/net/s2io.o | 460768 -> 460120 (-648 bytes)
> >
> >  drivers/net/s2io.c |   14 +++++---------
> >  1 file changed, 5 insertions(+), 9 deletions(-)
> 
> ACK but didn't apply, please wait 24-48 hours (so that s2io fixes go
> upstream), then rediff and resend
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
