Return-Path: <linux-kernel-owner+w=401wt.eu-S1754123AbXEBTLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbXEBTLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 15:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754183AbXEBTLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 15:11:19 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52148 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754123AbXEBTLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 15:11:17 -0400
Date: Wed, 2 May 2007 20:15:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Ioan Ionita" <opslynx@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       htejun@gmail.com
Subject: Re: More JMicron troubles with 2.6.21
Message-ID: <20070502201511.4c8085e9@the-village.bc.nu>
In-Reply-To: <df47b87a0705021037k7dc2d408mcdddbc83daa3b68b@mail.gmail.com>
References: <df47b87a0705021037k7dc2d408mcdddbc83daa3b68b@mail.gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I have an Asus Commando Mobo with one of those dreadful JMicron
> controllers (JMicron 20360/20363 AHCI Controller (rev 02). I have a

The Jmicron controllers get a lot of testing so should run smoothly.

> I can't get my CD-RW to work. have tried the pata_jmicron driver and
> the JMicron  ide driver, no success.

This is almost certainly a problem outside of the IDE handling in that
case. The jmicron controllers are smart, there is basically no code to
the IDE driver to go wrong (especially in the case of using the old IDE
for the PATA port where you basically use zero code that hasn't been
tested for years).

Do you get the odd timeout or continuous timeouts ?
