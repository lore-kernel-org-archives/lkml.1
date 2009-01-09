Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbZAIS3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbZAIS3b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 13:29:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbZAIS3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 13:29:22 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58403 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751876AbZAIS3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 13:29:21 -0500
Date: Fri, 9 Jan 2009 18:29:24 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dick Hollenbeck <dick@softplc.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: New true IDE compact flash driver starting point?
Message-ID: <20090109182924.2d7580c2@lxorguk.ukuu.org.uk>
In-Reply-To: <4967977E.5010504@softplc.com>
References: <49659E41.5070001@softplc.com>
	<200901081318.44188.arnd@arndb.de>
	<49661B0F.6030206@softplc.com>
	<200901091733.16931.arnd@arndb.de>
	<4967977E.5010504@softplc.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 1) Since this is for a quasi realtime application, is there any 
> advantage to using the interrupt line regarding how the CPU spends its 
> idle time waiting for the flash?  (I have an interrupt line I can use.)  
> Currently I am not sending in the IRQ resource, resource array length of 
> 2, not 3.

For real time you may actually be better with the IRQless polling
behaviour as the driver and ATA library currently stands.
