Return-Path: <linux-kernel-owner+w=401wt.eu-S1755389AbZFVNZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbZFVNZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 09:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbZFVNZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 09:25:25 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42194 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbZFVNZY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 09:25:24 -0400
From: "Pandita, Vikram" <vikram.pandita@ti.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Tony Lindgren <tony@atomide.com>
CC: Marc Zyngier <maz@misterjones.org>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Date: Mon, 22 Jun 2009 18:54:45 +0530
Subject: RE: [PATCH] serial: 8250: add IRQ trigger support
Thread-Topic: [PATCH] serial: 8250: add IRQ trigger support
Thread-Index: AcnzPJMYgSbZz+/PTPyz2pDbWDGqmAAABujg
Message-ID: <FCCFB4CDC6E5564B9182F639FC35608702F54618F0@dbde02.ent.ti.com>
References: <1244827971-14981-1-git-send-email-vikram.pandita@ti.com>
	<20090612213127.0f03e0c5@taxman.wild-wind.fr.eu.org>
	<20090622124037.GD7352@atomide.com>
 <20090622142402.5e36e7fd@lxorguk.ukuu.org.uk>
In-Reply-To: <20090622142402.5e36e7fd@lxorguk.ukuu.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk]
>Sent: Monday, June 22, 2009 8:24 AM
>To: Tony Lindgren
>Cc: Marc Zyngier; Pandita, Vikram; linux-serial@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
>omap@vger.kernel.org; linux-arm-kernel@lists.arm.linux.org.uk
>Subject: Re: [PATCH] serial: 8250: add IRQ trigger support
>
>> To me it sounds like the it would be better to have unsigned
>> long irqflags in struct uart_port instead of trying to squeeze
>> the irqflags the flags field. We're already not covering all the
>> irqflags currently like Marc pointed out.
>
>Agreed.

I can post a patch with new irqflags in uart_port.
Expect a patch today.

>
>Alan

