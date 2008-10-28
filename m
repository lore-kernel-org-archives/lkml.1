Return-Path: <linux-kernel-owner+w=401wt.eu-S1754313AbYJ1V5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313AbYJ1V5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 17:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285AbYJ1V4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 17:56:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56072 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969AbYJ1V4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 17:56:53 -0400
Message-ID: <49078A97.8020003@redhat.com>
Date: Tue, 28 Oct 2008 17:56:39 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Andreas Dilger <adilger@sun.com>, Josef Bacik <jbacik@redhat.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: [PATCH] improve jbd fsync batching
References: <20081028201614.GA21600@unused.rdu.redhat.com>	<20081028213805.GC3184@webber.adilger.int> <20081028144401.07b7546d@infradead.org>
In-Reply-To: <20081028144401.07b7546d@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Tue, 28 Oct 2008 15:38:05 -0600
> Andreas Dilger <adilger@sun.com> wrote:
>
>   
>> On Oct 28, 2008  16:16 -0400, Josef Bacik wrote:
>>     
>>> I also have a min() check in there to make sure we don't sleep
>>> longer than a jiffie in case our storage is super slow, this was
>>> requested by Andrew.
>>>       
>> Is there a particular reason why 1 jiffie is considered the "right
>> amount" of time to sleep, given this is a kernel config parameter and
>> has nothing to do with the storage?  Considering a seek time in the
>> range of ~10ms this would only be right for HZ=100 and the wait would
>>     
>
> well... my disk does a 50 usec seek time or so.. so I don't mind ;-)
>
> in fact it sounds awefully long to me.
>   

For small writes as well as reads?

If so, it would be great to test Josef's patch against your shiny new 
SSD  :-)

ric

