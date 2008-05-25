Return-Path: <linux-kernel-owner+w=401wt.eu-S1757610AbYEYLd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610AbYEYLd4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 07:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbYEYLdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 07:33:47 -0400
Received: from mail.scaimas.com ([195.82.67.50]:19014 "EHLO mail.scaimas.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753788AbYEYLdq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 07:33:46 -0400
content-class: urn:content-classes:message
Subject: Re: Limit SATA link speed to 1.5 Gbps
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Date: Sun, 25 May 2008 13:33:44 +0200
Message-ID: <F7D77F204D5F7641AB3864C88E39498F186159@taube3.scailokal.intern>
X-MimeOLE: Produced By Microsoft Exchange V6.0.6619.12
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Re: Limit SATA link speed to 1.5 Gbps
Thread-Index: Aci8AOthirlgG+LLTb2/xStWyNZ5DwCWZeOw
References: <F7D77F204D5F7641AB3864C88E39498F18614E@taube3.scailokal.intern> <20080522122905.49cca18d@core>
From: "Andre Pietsch" <andre.pietsch@scai.de>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I tested 2.6.25 and the error still occurrs once but then it gave me
a "limiting SATA link speed to 1.5 Gbps" in the log.
> 
> The later kernels will drop the SATA speed on repeated errors if they
see what appears to be a consistent problem that might be cabling/noise.
> 
> > Is it possible to set the SATA link speed somewhere?
> 
> Not sure. I've not looked whether that is in the new "force" code. I
don't think you can in 2.6.24 however, and 2.6.25 will fall back nicely.
> 
> Other than being annoying during the install it should not cause any
other problems beyond all the retries. 

Hi Alan,

thanks for your input. I can report that Ubuntu 8.0.4 64 does behave the
same way as the 32 Bit version and limits the link speed successfully,
after the link fails several times.

After this the errors do not occurr any more.

This works for me now. I'll update the bug report on launchpad.

Regards,
Andre Pietsch
