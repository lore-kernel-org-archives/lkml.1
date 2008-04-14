Return-Path: <linux-kernel-owner+w=401wt.eu-S1763337AbYDNXJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763337AbYDNXJv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 19:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762921AbYDNXJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 19:09:28 -0400
Received: from atlanta.zankel.net ([69.61.78.146]:3992 "EHLO
	atlanta.zankel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762850AbYDNXJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 19:09:27 -0400
X-Greylist: delayed 516 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Apr 2008 19:09:27 EDT
Message-ID: <4803E220.6030807@zankel.net>
Date: Mon, 14 Apr 2008 16:00:48 -0700
From: Chris Zankel <chris@zankel.net>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] xtensa: don't offer PARPORT_PC
References: <20080414195551.GE26885@cs181133002.pp.htv.fi> <20080414223124.6b92de11@core> <20080414221312.GI26885@cs181133002.pp.htv.fi>
In-Reply-To: <20080414221312.GI26885@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

Most of the boards with Xtensa don't have PCI, and the PCI bridge on the
two boards I know have PCI are more or less broken. One (with a V3)
doesn't support byte/word accesses and the other one has broken
PCI-Master to main memory connection. I'll work on the one that has
only 32-bit access and will try to fix it.


Thanks,
-Chris

Adrian Bunk wrote:
> On Mon, Apr 14, 2008 at 10:31:24PM +0100, Alan Cox wrote:
>> On Mon, 14 Apr 2008 22:55:51 +0300
>> Adrian Bunk <bunk@kernel.org> wrote:
>>
>>> This patch fixes the following compile error:
>>>
>>> <--  snip  -->
>>>
>>> ...
>>>   CC [M]  drivers/parport/parport_pc.o
>>> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/parport/parport_pc.c:67:25: error: asm/parport.h: No such file or directory
>>> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/parport/parport_pc.c: In function 'parport_pc_find_ports':
>>> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/parport/parport_pc.c:3215: error: implicit declaration of function 'parport_pc_find_nonpci_ports'
>>> make[3]: *** [drivers/parport/parport_pc.o] Error 1
>>>
>>> <--  snip  -->
>>>
>>> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>> If xtensa has PCI then if you fix up the headers so the PCI stuff works
>> we'll be in a better shape.
> 
> The only merged platform does not support PCI, and I don't have any 
> xtensa hardware for knowing what to put there.
> 
> Chris?
> 
> cu
> Adrian
> 

