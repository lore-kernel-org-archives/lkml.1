Return-Path: <linux-kernel-owner+w=401wt.eu-S1755619AbYFPUWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619AbYFPUWO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 16:22:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752739AbYFPUV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 16:21:59 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59721 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552AbYFPUV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 16:21:59 -0400
Message-ID: <4856CB61.6030202@garzik.org>
Date: Mon, 16 Jun 2008 16:21:53 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       jaswinder@infradead.org
Subject: Re: [PATCH] ip2: use request_firmware()
References: <1213609751.26255.673.camel@pmac.infradead.org>	<20080616115950.41bc65aa@lxorguk.ukuu.org.uk>	<4856C6C8.6060506@garzik.org>	<4856C795.2050007@garzik.org> <20080616205820.1fe298d7@lxorguk.ukuu.org.uk>
In-Reply-To: <20080616205820.1fe298d7@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> There is no reason why firmware must be artificially separated into 
>> firmware/
> 
> It seems a good step towards kicking it all out of the kernel tree into
> user space where it belongs.

Why does that goal need a toplevel directory in the kernel source tree, 
one that ultimately must mirror the other hierarchies already in the tree?

It's better to have drivers/char/ip2.ihex and keep everything related to 
a single driver in one place.

Extracting the firmware:  good

Scattering a /single/ driver across multiple directories in the kernel 
tree:  bad

	Jeff



