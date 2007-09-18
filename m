Return-Path: <linux-kernel-owner+w=401wt.eu-S1757323AbXIRMXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323AbXIRMXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 08:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755933AbXIRMXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 08:23:08 -0400
Received: from pils.linux-kernel.at ([213.129.242.82]:5377 "EHLO
	mail.linux-kernel.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755813AbXIRMXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 08:23:07 -0400
Message-ID: <46EFC2A8.9070009@linux-kernel.at>
Date: Tue, 18 Sep 2007 14:20:56 +0200
From: Oliver Falk <oliver@linux-kernel.at>
Organization: Linux kernel Austria
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070615 Fedora/2.0.0.4-1.fc7 Thunderbird/2.0.0.4 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Sergey Tikhonov <tsv@solvo.ru>
CC: Linux on Alpha processors <axp-list@redhat.com>,
       ac-admin@lists.anotherbloody.com, Adrian Bunk <bunk@kernel.org>,
       ink@jurassic.park.msu.ru, linux-kernel@vger.kernel.org,
       Jay Estabrook <jay.estabrook@hp.com>
Subject: Re: [AC-Admin] Re: 2.6.23 alpha unistd.h changes
References: <46EEE483.4020209@linux-kernel.at>	<20070917212257.GA27980@stusta.de>	<46EF922A.4030206@linux-kernel.at> <46EF962E.9010706@solvo.ru>
In-Reply-To: <46EF962E.9010706@solvo.ru>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-lkernAT-MailScanner-Information: Please contact the ISP for more information
X-lkernAT-MailScanner: Found to be clean
X-lkernAT-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-4.399, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -2.60)
X-MailScanner-From: oliver@linux-kernel.at
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2007 11:11 AM, Sergey Tikhonov wrote:
> Oliver Falk wrote:
>> On 09/17/2007 11:22 PM, Adrian Bunk wrote:
>>  
>>> On Mon, Sep 17, 2007 at 10:33:07PM +0200, Oliver Falk wrote:
>>>    
>>>> At Alphacore we used to patch the kernel headers for a while now; We
>>>> added syscalls __NR_openat (447) until __NR_tee (466).
>>>>       
>>> Why did your numbers differ from the numbers that were used in the
>>> upstream kernel?
>>>     
>>
>> Afaik, our patch was done a while ago and nobody every submitted it
>> upstream - don't know why...
>>   
> Yes, it was done by me and I had no info how to push the updates to
> upstream, sorry. (by that time,
> there were no latest "distribution" available with those changes).
>> At AC, we follow RH/Fedora packages and there we had glibc-kernheaders -
>> where our patch originates. When the glibc/kernel packages changed and
>> glibc-kernheaders died, I patched the syscalls into kernel headers; Not
>> thinking that I better submit it upstream. :-(
>>   
> Yea, now there is more interest and it is better to do it right. :)

To make it easy for everyone....

There should not be many AC users that run the latest versions of
everything.

I will keep the sorting of the syscalls as they are - no change required
upstream.

People who want new kernel or new glibc will then also need to update
the other. DOT. POINT. END. :-)

Kernel 2.6.23 will also require new aboot.... So many things....

Since online upgrading from AC3 to FC8axp will not be supported anyway
(because of various reasons and now 2 more of them), I can live with
that decision finally.

Thx everyone...

Best,
 Oliver
