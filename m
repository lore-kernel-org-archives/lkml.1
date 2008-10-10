Return-Path: <linux-kernel-owner+w=401wt.eu-S1758829AbYJJMgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829AbYJJMgu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 08:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755113AbYJJMgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 08:36:42 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:5705 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334AbYJJMgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 08:36:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=JRyUIL1OT6us8UBDv/MJwQOYP7D8YvvsjHoErDdo4f3vTBflbYmUtGxEA4wPVKnP2R
         kq9h9LtYHA7yj2aznilB6HkozBB0Kp7rPyUcaB0KTYvF9rRsX/pHVSYPCKmYItG/iSc+
         XvW8ocwHKz/GI/Lhvg/FE1ivcE9sAd1mdMTjM=
Message-ID: <48EF4C52.4070802@tuffmail.co.uk>
Date: Fri, 10 Oct 2008 13:36:34 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Yudha Harimantoro T <yudha.ht@gmail.com>, kernel-testers@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Error : Linux-2.6.27
References: <264b990a0810100126l1029f734x7204f8c42ae21609@mail.gmail.com> <20081010115342.GB25982@x200.localdomain>
In-Reply-To: <20081010115342.GB25982@x200.localdomain>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> On Fri, Oct 10, 2008 at 03:26:44PM +0700, Yudha Harimantoro T wrote:
>   
>> Yesterday I build kernel 2.6.26.6 and it's run well. Today I got
>> 2.6.27 patch and try to build it.
>>
>> I build with `make oldconfig` and answer any question with default
>> answer, I just press [enter].
>>     
>
> Not wise.
>
>   
>> I build with `make`. No error and all compiled.
>> Then I install with `make modules_install` and `make install`.
>>
>> After reboot the system I got 'kernel panic'.
>> This is the error picture :
>> http://www.ryht.co.cc/wordpress/wp-content/uploads/2008/10/pa101358.jpg
>> Is it a bugs?
>>
>> http://www.ryht.co.cc/wordpress/wp-content/uploads/2008/10/pa101353.jpg
>> [2.6.26.6 run well]
>>     
>
> Post diff -U0 between old and new config.
>   

There is scripts/diffconfig in the 2.6.27 tree, which you should
probably use. "Using standard diff to compare .config files often
includes extraneous and distracting information".

