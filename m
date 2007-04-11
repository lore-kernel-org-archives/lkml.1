Return-Path: <linux-kernel-owner+w=401wt.eu-S1751559AbXDKJKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559AbXDKJKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 05:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbXDKJKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 05:10:36 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:40521 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbXDKJKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 05:10:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:references:mime-version:content-type;
        b=qjsEnOenFiV9DICeQjOu1tVxMmyeeW2gWHUlxxbcoFTYJTc9tTCivGLy6nXwplwABWWnybbTfBQza381hzsmhAmHheV/hFY3wshY80V2/llATZhIVQ44qItIAWNgpki1uMN+l3eokNKmO0ugQSBm+rIoMndYSF5Y0CTHFGXE54c=
Date: Wed, 11 Apr 2007 11:10:27 +0200 (CEST)
From: Esben Nielsen <nielsen.esben@googlemail.com>
X-X-Sender: simlo@frodo.shire
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
cc: netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 20/30] Use menuconfig objects - ARCNET
In-Reply-To: <Pine.LNX.4.61.0704111034170.32056@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.64.0704111040000.13800@frodo.shire>
References: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
 <Pine.LNX.4.61.0704102329540.32056@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0704111014330.13800@frodo.shire> <Pine.LNX.4.61.0704111034170.32056@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 11 Apr 2007, Jan Engelhardt wrote:

>
> On Apr 11 2007 10:30, Esben Nielsen wrote:
>> On Tue, 10 Apr 2007, Jan Engelhardt wrote:
>>>
>>> (Wow, not a single MODULE_AUTHOR line in drivers/net/arcnet/ ...)
>>
>> ArcNet is old. Almost nobody is using it anymore. I used it at my
>> former job, since we used it as control network. A lot of companies
>> still does quitely, but not in combination with Linux.

Let me correct myself: I have only know of one company using the Linux 
ArcNet combination in production. But there must be other companies using 
ArcNet playing with Linux in R&D.

>
> So send some removal patches :)

No. Somebody (like me) in those companise use them sporadically for their 
PCI/PCMCIA cards. The vendor have some basic Windoze drives. Missing Linux 
drivers should not be yet another obstacle for using Linux.

They might also one day want to run Linux on their embedded platform - 
especially with preempt-realtime. When I at my former job got Linux to boot
at our embedded platform their I could almost immediately use the onboard
ArcNet controller. For the propriatary OS otherwise used on those platforms it
took many man weeks to write a driver.

Keeping support for old devices in the kernel tree is a good for Linux. It 
should take too long updating it for API changes and although they might 
not work, but if the occational user is capable enough, he can soon fix 
them. If they are are removed the occational user will choose another OS.

Esben
