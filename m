Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab0CCHej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 02:34:39 -0500
Received: from mx1.auerswald.de ([212.185.163.234]:1290 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752701Ab0CCHei convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 02:34:38 -0500
From: Wolfgang =?iso-8859-1?q?M=FCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald Gesellschaft =?iso-8859-15?q?f=FCr_Datensysteme?= mbH
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/7] mmc: at91_mci: use DMA buffer for read
Date: Wed, 3 Mar 2010 08:34:31 +0100
User-Agent: KMail/1.13.0 (Linux/2.6.31-19-generic; KDE/4.4.0; i686; ; )
Cc: "Nicolas Ferre" <nicolas.ferre@atmel.com>, linux-mmc@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       avictor.za@gmail.com
References: <20100302133434.761df661.akpm@linux-foundation.org>
In-Reply-To: <20100302133434.761df661.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003030834.31457.wolfgang.mues@auerswald.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Am Dienstag, 2. März 2010 schrieb Andrew Morton:
> Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> > +		kunmap_atomic(((void *)sgbuffer)-sg->offset, KM_BIO_SRC_IRQ);
> 
> It's a feature of kunmap_atomic() that it will accept a pointer to any
> location in the page.  So the subtraction isn't strictly needed.
> 
> And if the subtraction is removed, the (void*) cast can also be removed.

I did not know this. Thank you for pointing this out. So this part of the 
patch (which was purely cosmetic because I have seen no error without the 
subtraction) can be omitted.

best regards
 
i. A. Wolfgang Mües
-- 
Auerswald Gesellschaft für Datensysteme mbH
Hardware Development
Telefon: +49 (0)5306 9219 562
Telefax: +49 (0)5306 9219 94 
E-Mail: Wolfgang.Mues@Auerswald.de
Web: http://www.auerswald.de
 
--------------------------------------------------------------
Auerswald Gesellschaft für Datensysteme mbH
Vor den Grashöfen 1, 38162 Cremlingen
Registriert beim AG Braunschweig HRB 7499
Geschäftsführer: Dipl-Ing. Gerhard Auerswald
