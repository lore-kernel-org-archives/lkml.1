Return-Path: <linux-kernel-owner+w=401wt.eu-S1755944AbXIRJZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944AbXIRJZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 05:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754253AbXIRJZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 05:25:12 -0400
Received: from gate.solvo.ru ([195.201.44.254]:57105 "EHLO gate.solvo.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415AbXIRJZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 05:25:11 -0400
X-Greylist: delayed 809 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Sep 2007 05:25:10 EDT
Message-ID: <46EF962E.9010706@solvo.ru>
Date: Tue, 18 Sep 2007 13:11:10 +0400
From: Sergey Tikhonov <tsv@solvo.ru>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Linux on Alpha processors <axp-list@redhat.com>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       ink@jurassic.park.msu.ru, ac-admin@lists.anotherbloody.com,
       Jay Estabrook <jay.estabrook@hp.com>
Subject: Re: 2.6.23 alpha unistd.h changes
References: <46EEE483.4020209@linux-kernel.at>	<20070917212257.GA27980@stusta.de> <46EF922A.4030206@linux-kernel.at>
In-Reply-To: <46EF922A.4030206@linux-kernel.at>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Milter: Spamilter (Reciever: gate.solvo.ru; Sender-ip: 172.16.80.12; Sender-helo: tiger.solvo.ru;)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Falk wrote:
> On 09/17/2007 11:22 PM, Adrian Bunk wrote:
>   
>> On Mon, Sep 17, 2007 at 10:33:07PM +0200, Oliver Falk wrote:
>>     
>>> At Alphacore we used to patch the kernel headers for a while now; We
>>> added syscalls __NR_openat (447) until __NR_tee (466).
>>>       
>> Why did your numbers differ from the numbers that were used in the 
>> upstream kernel?
>>     
>
> Afaik, our patch was done a while ago and nobody every submitted it
> upstream - don't know why...
>   
Yes, it was done by me and I had no info how to push the updates to 
upstream, sorry. (by that time,
there were no latest "distribution" available with those changes).
> At AC, we follow RH/Fedora packages and there we had glibc-kernheaders -
> where our patch originates. When the glibc/kernel packages changed and
> glibc-kernheaders died, I patched the syscalls into kernel headers; Not
> thinking that I better submit it upstream. :-(
>   
Yea, now there is more interest and it is better to do it right. :)

Regards,

-- 
Sergey Tikhonov

Head, R&D department
Solvo Ltd.
Saint-Petersburg, Russia
http://www.solvo.ru
tsv@solvo.ru

