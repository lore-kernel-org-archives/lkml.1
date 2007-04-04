Return-Path: <linux-kernel-owner+w=401wt.eu-S964974AbXDDF3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964974AbXDDF3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 01:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966301AbXDDF3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 01:29:23 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:33897 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964974AbXDDF3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 01:29:22 -0400
Message-ID: <4613379D.1000503@cosmosbay.com>
Date: Wed, 04 Apr 2007 07:29:01 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Ulrich Drepper <drepper@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: Re: getting processor numbers
References: <461286D6.2040407@redhat.com> <Pine.LNX.4.64.0704031152370.23808@alien.or.mcafeemobile.com> <4612ABD7.3000201@redhat.com> <4612F1F0.5070209@zytor.com> <4612F2BF.7080704@goop.org> <4612F394.6040105@zytor.com> <4613330C.1020701@cosmosbay.com> <461334B5.7070607@zytor.com>
In-Reply-To: <461334B5.7070607@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Wed, 04 Apr 2007 07:29:09 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin a écrit :
> Eric Dumazet wrote:
>>
>> There is one thing that always worried me.
>>
>> Intel & AMD manuals make clear that mixing data and program in the 
>> same page is bad for performance.
>>
>> In particular, x86_64 vsyscall put jiffies and other 
>> vsyscall_gtod_data_t right in the midle of code. That is certainly not 
>> wise.
>>
>> A probably sane implementation should use two pages, one for code, one 
>> for data.
>>
> 
> Mutable data should be separated from code.  I think any current CPU 
> will do fine as long as they are in separate 128-byte chunks, but they 
> need at least that much separation.
> 
> Readonly data does not need to be separated from code.
> 

Yes... jiffies & vsyscall_gtod_data_t is writen HZ times per second.

Not really readonly I'm afraid.


