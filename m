Return-Path: <linux-kernel-owner+w=401wt.eu-S932247AbZLNR1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247AbZLNR1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 12:27:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932225AbZLNR1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 12:27:35 -0500
Received: from exprod6ob111.obsmtp.com ([64.18.1.26]:39083 "EHLO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932202AbZLNR1e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 12:27:34 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH] au1xxx-ide.c: ioremap() returns a void __iomem *
Date: Mon, 14 Dec 2009 12:27:29 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200E9AD@mi8nycmail19.Mi8.com>
In-Reply-To: <20091213.205212.212692978.davem@davemloft.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] au1xxx-ide.c: ioremap() returns a void __iomem *
Thread-Index: Acp8eTMHPJGGY6wBSTKbOns8bMhuMgAZo4wg
References: <BD79186B4FD85F4B8E60E381CAEE190901FB10C2@mi8nycmail19.Mi8.com><4B241F10.7050706@ru.mvista.com> <20091213.205212.212692978.davem@davemloft.net>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "David Miller" <davem@davemloft.net>, <sshtylyov@ru.mvista.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>
X-OriginalArrivalTime: 14 Dec 2009 17:27:30.0707 (UTC) FILETIME=[B6EF4E30:01CA7CE2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, December 13, 2009 9:52 PM, David Miller wrote:
>
> From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> Date: Sun, 13 Dec 2009 01:54:08 +0300
> 
>> H Hartley Sweeten wrote:
>> 
>>> The ioremap return value is an __iomem *, not an integer.  Update the
>>> private structure to reflect this.  While here, remove the typedef
>>> for _auide_hwif and just use struct auide_hwif instead as recommended
>>> by Documentation/CodingStyle.
>>>
>>> auide_setup_ports() still needs to cast the regbase back to an integer
>>> to correctly setup the io_ports_array.
>>>
>>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
 ...
>>>     a) 'arch/mips/include/asm/mach-au1x00/au1xxx_ide.h'
>>> -     containes : struct _auide_hwif
>>> +     containes : struct auide_hwif
>>>   
>> 
>>   Contains?
>> 
>>   Other than that,
>> 
>> Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

Oops... Did not notice that spelling error.  Will fix and repost the patch.

> Also, this patch doesn't apply to the current tree, the
> au_ide_remove() function has been fixed to use
> resource_size().
>
> Please respin your patch, and also incorporate the
> documentation spelling fix suggested by Sergei (and
> make sure to keep the alignment of that section of
> documentation when you do that).

Hmmm.. That patch was also mine.  I waited until it was merged before creating
this one. It should have accounted for that.  I will recheck the patch to see
what was missed.

Regards,
Hartley
