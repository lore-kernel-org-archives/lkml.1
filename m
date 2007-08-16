Return-Path: <linux-kernel-owner+w=401wt.eu-S1762130AbXHPG5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762130AbXHPG5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 02:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760197AbXHPG5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 02:57:15 -0400
Received: from mx.neterion.com ([72.1.205.142]:59546 "EHLO owa.neterion.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107AbXHPG5N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 02:57:13 -0400
X-Greylist: delayed 890 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Aug 2007 02:57:13 EDT
X-MIMEOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: drivers/net/tokenring/3c359.c
Date: Thu, 16 Aug 2007 02:43:11 -0400
Message-ID: <78C9135A3D2ECE4B8162EBDCE82CAD77020EEEC6@nekter>
In-Reply-To: <46C14297.1050800@garzik.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: drivers/net/tokenring/3c359.c
Thread-Index: AcfeN3nUAe5Q4d0VQROafDcjwa9ouABmACug
References: <1187000010.29518.27.camel@bluegenie> <46C14297.1050800@garzik.org>
From: "Sivakumar Subramani" <Sivakumar.Subramani@neterion.com>
To: "Jeff Garzik" <jeff@garzik.org>, <surya.prabhakar@wipro.com>
Cc: <mikep@linuxtr.net>, <netdev@vger.kernel.org>, <linux-tr@linuxtr.net>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "kernel-janitors" <kernel-janitors@lists.osdl.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

What exactly the difference between kzalloc and kcalloc? From the
definition, I could see that kcalloc should be used for array
allocation. But I could see kzalloc is used for allocation arrays as in
the below patch.

Any coding standard (or) developers can use kzalloc and kcalloc as per
their coding practice??

Thanks,
~Siva
-----Original Message-----
From: netdev-owner@vger.kernel.org [mailto:netdev-owner@vger.kernel.org]
On Behalf Of Jeff Garzik
Sent: Tuesday, August 14, 2007 11:20 AM
To: surya.prabhakar@wipro.com
Cc: mikep@linuxtr.net; netdev@vger.kernel.org; linux-tr@linuxtr.net;
Linux Kernel; kernel-janitors
Subject: Re: drivers/net/tokenring/3c359.c

Surya Prabhakar N wrote:
> Hi,
>    Replacing kmalloc with kzalloc and cleaning up memset in 
> drivers/net/tokenring/3c359.c
> 
> 
> Signed-off-by: Surya Prabhakar <surya.prabhakar@wipro.com>

applied


-
To unsubscribe from this list: send the line "unsubscribe netdev" in the
body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html
