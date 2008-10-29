Return-Path: <linux-kernel-owner+w=401wt.eu-S1755250AbYJ2WiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbYJ2WiX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 18:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751464AbYJ2WiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 18:38:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58625 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752112AbYJ2WiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 18:38:13 -0400
Message-ID: <4908E5B6.1080703@redhat.com>
Date: Wed, 29 Oct 2008 18:37:42 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: "Phillip O'Donnell" <phillip.odonnell@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Oskar Liljeblad <oskar@osk.mine.nu>,
       Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
Subject: Re: sata errors with Seagate 1.5TB on AMD 780G/SB700 motherboard
References: <fa.01zEaARwrup2dCOTuHTYxzuS9BI@ifi.uio.no>	 <49079E09.20703@shaw.ca> <20081029185856.GA8152@osk.mine.nu>	 <20081029201724.0a7d736e@lxorguk.ukuu.org.uk>	 <4908C62E.5070307@redhat.com> <7a9b5c320810291352k5db86a4eg4e03fb09317de459@mail.gmail.com>
In-Reply-To: <7a9b5c320810291352k5db86a4eg4e03fb09317de459@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip O'Donnell wrote:
> Hi Ric,
>
> Not too sure about that - I run with XFS, which announces that it
> disables the barriers on my devices (I use LVM on top of them) but
> still get the same issue... Unless I've misunderstood your comment?
>
> Cheers,
> Phillip
>   
XFS has a different issue with barriers that has been recently fixed.

I am just going based on what I read at the Seagate customer site - it 
looks like the hang was during the processing of the ATA_CACHE_FLUSH_EXT 
command.

New drives are routinely buggy to some degree, especially ones that jump 
up in capacity :-)  Seagate has a well earned reputation for quality and 
I will be surprised if they don't fix this issue soon,

Ric

>   
>> I suspect that the drive is simply choking on the barrier related cache
>> flushing that we do - that seemed to be the MacOS error as well. The windows
>> comment suggested that windows had an hba/driver bug (most likely unrelated
>> to this).
>>
>> If you want to avoid the issue until they fix the drive, you could run fast
>> and dangerous (mount without barriers on) or slow and safe (disable the
>> write cache).
>>     

