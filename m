Return-Path: <linux-kernel-owner+w=401wt.eu-S1766913AbXDDTuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766913AbXDDTuu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 15:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766910AbXDDTuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 15:50:50 -0400
Received: from rwcrmhc14.comcast.net ([204.127.192.84]:42675 "EHLO
	rwcrmhc14.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766906AbXDDTus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 15:50:48 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Apr 2007 15:50:48 EDT
Message-ID: <461400A1.7080907@wolfmountaingroup.com>
Date: Wed, 04 Apr 2007 13:46:41 -0600
From: "Jeff V. Merkey" <jmerkey@wolfmountaingroup.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20050921 Red Hat/1.7.12-1.4.1
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
CC: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Latest e1000 7.3.20 driver busted with 2.6.20.4
References: <4613E230.6080608@wolfmountaingroup.com> <4613FD2C.101@intel.com>
In-Reply-To: <4613FD2C.101@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kok, Auke wrote:

> Jeff V. Merkey wrote:
>
>> CC [M]  drivers/net/chelsio/mv88x201x.o
>>   CC [M]  drivers/net/chelsio/my3126.o
>>   LD [M]  drivers/net/chelsio/cxgb.o
>>   CC      drivers/net/e1000/e1000_main.o
>> drivers/net/e1000/e1000_main.c:1185:45: error: macro "INIT_WORK" 
>> passed 3 arguments, but takes just 2
>> ared (first use in this function)
>> drivers/net/e1000/e1000_main.c:1184: error: (Each undeclared 
>> identifier is reported only once
>> drivers/net/e1000/e1000_main.c:1184: error: for each function it 
>> appears in.)
>> make[3]: *** [drivers/net/e1000/e1000_main.o] Error 1
>> make[2]: *** [drivers/net/e1000] Error 2
>> make[1]: *** [drivers/net] Error 2
>> make: *** [drivers] Error 2
>
>
> this is hardly a thread for lkml as you're posting about out 
> out-of-tree driver.  This issue has also been fixed in 7.4.35 which 
> was released last week on e1000.sf.net. In the future, please post 
> this stuff to e1000-devel@lists.sourceforge.net where we discuss the 
> out-of-tree driver.
>
> Cheers,
>
> Auke
>
Thanks.  I'll download Intel's latest driver and test it.   I wasn't 
discussing the out of tree driver (why do you have a broken Linux out of 
tree driver, BTW?   If its for Linux, shouldn't it be updated here 
first) but the driver in 2.6.20.4 (which is missing support four 
additional chipsets). 

Jeff
