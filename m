Return-Path: <linux-kernel-owner+w=401wt.eu-S936617AbXLQXZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936617AbXLQXZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 18:25:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757500AbXLQXZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 18:25:13 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:52421 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756755AbXLQXZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:25:11 -0500
Date: Tue, 18 Dec 2007 00:25:10 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Parag Warudkar <parag.warudkar@gmail.com>, devzero@web.de,
       Matt.Domsch@dell.com, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] be more verbose when probing EDD
In-Reply-To: <20071216201849.24f7aa5f@the-village.bc.nu>
Message-ID: <Pine.LNX.4.64.0712180023310.32270@fbirervta.pbzchgretzou.qr>
References: <49448787@web.de> <82e4877d0712161159r2572dbbfi15159c66e4b7e33b@mail.gmail.com>
 <20071216201849.24f7aa5f@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 16 2007 20:18, Alan Cox wrote:
>
>> Why tax other people with a warning/hang etc. in printk when the
>> problem is very unlikely on their systems?
>
>I think there is sense in it if you do it subtly differently.
>
>	printk(".. if this hangs do ... \r");
>	edd_stuff();
>	printk("                          \r");
>	
>
>So that we display it, do the EDD call, then write over it with whatever
>is next that matters.

Does printk support escape sequences? The last time I tried
printk("\e[1;35m omg ponies \e[0m"); that did not went too successful.

>That way you'd only see it when it hung - and that might be worth a patch
>and test from someone.
