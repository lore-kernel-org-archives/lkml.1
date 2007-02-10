Return-Path: <linux-kernel-owner+w=401wt.eu-S1751263AbXBJRAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751263AbXBJRAK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 12:00:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbXBJRAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 12:00:10 -0500
Received: from smtp23.orange.fr ([80.12.242.50]:20481 "EHLO smtp23.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263AbXBJRAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 12:00:08 -0500
X-ME-UUID: 20070210170006162.27B6E1C00097@mwinf2349.orange.fr
Message-ID: <45CDF9F1.4060809@wanadoo.fr>
Date: Sat, 10 Feb 2007 17:59:29 +0100
From: Thibaud Hulin <hulin.thibaud@wanadoo.fr>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Alex Davis <alex14641@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Problem of USB - error 71 : how configure kernel to dongle with
 chipset
References: <292704.97873.qm@web50210.mail.yahoo.com>
In-Reply-To: <292704.97873.qm@web50210.mail.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks. In effect, I already post this question in the ndiswrapper list. 
So, they told me that was a problem of USB and of kernel. Then, I'm 
looking for configuration of the kernel, because I compiled the 2.6.19, 
but I no more success. Actually, lsusb recognize, then don't recognize 
the machine a few seconds after. Ndiswrapper can be installed or not, 
that change nothing.

This is the answer from which I was able to touch with you :

--- Thibaud Hulin <hulin.thibaud@wanadoo.fr> wrote:

 > > So, 30 seconds later, the dongle is not recognize. lsusb give :
 > > Bus 001 Device 001: ID 0000:0000
 > > So, I can't use my dongle.

If 'lsusb' doesn't see the card, it may indicate problem with your USB host
(either hardware, or host driver or both). You may want to try different
kernels. Until that part works right, ndiswrapper won't be able to 
initialize
the card.

Giri

Alex Davis a écrit :
> As you are using ndiswrapper, you won't much if any help from the kernel developers.
> ndiswrapper taints the kernel as it links closed-source drivers into kernel space.
> 
> I strongly advise you to post this question on the ndiswrapper mailing list.
> 
> Good luck.
> 
> -Alex

