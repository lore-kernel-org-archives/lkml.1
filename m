Return-Path: <linux-kernel-owner+w=401wt.eu-S1754969AbZDVPNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969AbZDVPNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 11:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755062AbZDVPNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 11:13:06 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:60041 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325AbZDVPNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 11:13:05 -0400
Message-ID: <49EF336B.5070807@oracle.com>
Date: Wed, 22 Apr 2009 08:10:35 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
CC: Michael Ellerman <michael@ellerman.id.au>, subrata@linux.vnet.ibm.com,
       sachinp <sachinp@linux.vnet.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>,
       "David A. Schleef" <ds@schleef.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
       linux-next <linux-next@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: [BUILD FAILURE 09/12] Next April 21 : PPC64 randconfig [drivers/staging/comedi/drivers.o]
References: <1240340029.9110.142.camel@subratamodak.linux.ibm.com> <1240358910.6571.6.camel@localhost> <alpine.LRH.2.00.0904220942430.6852@vixen.sonytel.be>
In-Reply-To: <alpine.LRH.2.00.0904220942430.6852@vixen.sonytel.be>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.49EF333D.004D:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> On Wed, 22 Apr 2009, Michael Ellerman wrote:
>> On Wed, 2009-04-22 at 00:23 +0530, Subrata Modak wrote:
>>> Reported this error on 14th April:
>>> http://lkml.org/lkml/2009/4/14/488,
>>>
>>> CC [M]  drivers/staging/comedi/drivers.o 
>>> drivers/staging/comedi/drivers.c: In function ‘comedi_buf_alloc’:
>>> drivers/staging/comedi/drivers.c:496: error: ‘PAGE_KERNEL_NOCACHE’
>>> undeclared (first use in this function)
>>> drivers/staging/comedi/drivers.c:496: error: (Each undeclared identifier
>>> is reported only once
>>> drivers/staging/comedi/drivers.c:496: error: for each function it
>>> appears in.)
>>> make[3]: *** [drivers/staging/comedi/drivers.o] Error 1
>>> make[2]: *** [drivers/staging/comedi] Error 2
>>> make[1]: *** [drivers/staging] Error 2
>>> make: *** [drivers] Error 2
>> Subrata, unless someone says otherwise, please do not send randconfig
>> failures for drivers in staging - those drivers have bigger problems
>> than randconfig failures.
> 
> Indeed, in particular this one http://lkml.org/lkml/2009/3/9/349.
> 
>> To avoid them, do this:
>>
>> # make randconfig
>> # sed -i -e 's/^\(CONFIG_STAGING\)=y/# \1 is not set/' .config
>                                        ^^^^^^^^^^^^^^^
> Recently I discovered that `n' actually works, too!

Yes, I've been using =n for quite awhile to disable a config symbol.

>> # make oldconfig


-- 
~Randy
