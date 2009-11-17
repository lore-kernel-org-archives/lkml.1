Return-Path: <linux-kernel-owner+w=401wt.eu-S1756157AbZKQTDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbZKQTDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 14:03:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754535AbZKQTDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 14:03:40 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:10499 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587AbZKQTDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 14:03:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Kma6384OkmZghnbNzkq7HNDxj5HHYf1TjUB7MSF+yU1YE6aGD4cjK3p82fp+115lIg
         n4g7p0LAlyQxtbEhg59tWtkarr0szdFOQPdVLBTUhuslJ5IbhfJP0+U8euMAxrzJPTV/
         0m+JWoncWJyM//P9rzrgqGLruxssCKFrXYtLI=
Message-ID: <4B02F3B7.2090907@gmail.com>
Date: Tue, 17 Nov 2009 11:04:23 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009022519)
MIME-Version: 1.0
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [Bug #14267] Disassociating atheros wlan
References: <ipicVA1QUFF.A.zWB.1mdALB@chimera>	<OWmO9uyC1hM.A.yiC._ndALB@chimera>	<4B01F3FE.8040707@gmail.com>	<20091117113320.8aef894a.kristoffer.ericson@gmail.com>	<4B02E64D.2010700@gmail.com> <20091117191357.7c64ba70.kristoffer.ericson@gmail.com>
In-Reply-To: <20091117191357.7c64ba70.kristoffer.ericson@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kristoffer Ericson wrote:
> On Tue, 17 Nov 2009 10:07:09 -0800
> "Justin P. Mattock"<justinmattock@gmail.com>  wrote:
>
>    
>> Kristoffer Ericson wrote:
>>      
>>> Im still hitting this so basicly using 2.6.30 until it get sorted. Will try and make
>>> some time to test the different commits. Last time I waited for it to disconnect which
>>> could take 10-40min. Since it depends on the network load Im now going to increase
>>> the load to see if I hit it quicker (and thus finding the error commit).
>>>
>>> So in short, its still valid and I will try and make time to fix it :)
>>>
>>>
>>>
>>>
>>>        
>> o.k. so it is something that is enough to
>> cause an inconvenience.
>>      
>
> Especially if you are using your computer as a router to other computers
> and they start screaming every time internet goes down. :(
>
>    
>>      
>
>
>    
ah. yeah I'm not doing that over here
just simply connecting to a router and streaming music.
my guess is you can try the commits that I found
but then again might not get you in the right
direction i.g. during the bisect I was watching the
"retry" in dmesg with ath* as soon as I saw that it was git bisect bad
(seems like a new mechanism) as soon as I didn't see
that the commit was good.

In your case you might be seeing something different(not sure though)
because of having the computer as a router etc..

Justin P. Mattock
