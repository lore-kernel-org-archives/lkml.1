Return-Path: <linux-kernel-owner+w=401wt.eu-S1756734AbZAJPDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbZAJPDc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 10:03:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753666AbZAJPDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 10:03:23 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:34468 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583AbZAJPDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 10:03:23 -0500
Message-ID: <4968B8A9.3060408@garzik.org>
Date: Sat, 10 Jan 2009 10:03:05 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: todays git: WARNING: at drivers/ata/libata-sff.c:1017	ata_sff_hsm_move+0x45e/0x750()
References: <200901091334.55823.borntraeger@de.ibm.com>	 <200901101009.13699.borntraeger@de.ibm.com>	 <20090110104114.633cacd8@lxorguk.ukuu.org.uk>	 <200901101242.05203.borntraeger@de.ibm.com>	 <49688B63.5030105@ru.mvista.com>	 <20090110122130.318cf168@lxorguk.ukuu.org.uk> <1231598170.3642.12.camel@localhost.localdomain>
In-Reply-To: <1231598170.3642.12.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> Your problem is that the *device* is wanting to transfer a set of bytes
> not divisible by four.

That's my initial guess, too...

	Jeff


