Return-Path: <linux-kernel-owner+w=401wt.eu-S1752004AbZG3Use@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbZG3Use (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 16:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751745AbZG3Usd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 16:48:33 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:43164 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629AbZG3Usc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 16:48:32 -0400
Date: Thu, 30 Jul 2009 22:48:31 +0200 (CEST)
From: Nicolas Palix <npalix@diku.dk>
To: Greg KH <gregkh@suse.de>
Cc: hjanssen@microsoft.com, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: hv: Replace typedef SG_BUFFER_LIST by struct
 scatterlist
In-Reply-To: <20090730195229.GB27953@suse.de>
Message-ID: <Pine.LNX.4.64.0907302242540.18173@ask.diku.dk>
References: <200907301737.23849.npalix@diku.dk> <20090730155844.GB20557@suse.de>
 <Pine.LNX.4.64.0907302020250.13698@ask.diku.dk> <20090730195229.GB27953@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jul 2009, Greg KH wrote:

> On Thu, Jul 30, 2009 at 08:35:08PM +0200, Nicolas Palix wrote:
>> On Thu, 30 Jul 2009, Greg KH wrote:
>>
>>> On Thu, Jul 30, 2009 at 05:37:23PM +0200, Nicolas Palix wrote:
>>>>
>>>> typedef SG_BUFFER_LIST is removed and its uses are replaced by the use of
>>>> struct scatterlist.
>>>
>>> Sweet!  thanks for doing this, very nice job, I'll go queue it up.
>>
>> I tried to change the RingBuffer too but I did not know
>> which API I should use.
>> The ring buffer in kernel/trace seems fine but it has some
>> dedicated features.
>>
>> Any hint?
>> Of which infrastructure are you thinking in your previous mail?
>
> I was thinking of include/linux/ring_buffer.h
>
> Does that not work for you?

It is perfect.

As its implementation is in kernel/trace and not in lib as scatterlist,
I just wanted to be sure before spending time on a patch. :)

thanks.

Nico

>
> thanks,
>
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
