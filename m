Return-Path: <linux-kernel-owner+w=401wt.eu-S1754845AbYJ2UXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbYJ2UXm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 16:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbYJ2UXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 16:23:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54858 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753939AbYJ2UXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 16:23:32 -0400
Message-ID: <4908C62E.5070307@redhat.com>
Date: Wed, 29 Oct 2008 16:23:10 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Oskar Liljeblad <oskar@osk.mine.nu>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: sata errors with Seagate 1.5TB on AMD 780G/SB700 motherboard
References: <fa.01zEaARwrup2dCOTuHTYxzuS9BI@ifi.uio.no>	<49079E09.20703@shaw.ca>	<20081029185856.GA8152@osk.mine.nu> <20081029201724.0a7d736e@lxorguk.ukuu.org.uk>
In-Reply-To: <20081029201724.0a7d736e@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> O> Anyway Seagate (inofficially) claims it's a driver issue in Linux - from
>   
>> http://forums.seagate.com/stx/board/message?board.id=ata_drives&thread.id=2390&view=by_date_ascending&page=6
>>     
>
> Well then perhaps they would care to share the information with us 8)
>
> The HPA size reporting one is certinly Linux, the flush cache one I don't
> think is. The fact Mac people report it and Seagate suggest workarounds
> of the form of "don't use 33% of the disk" don't inspire confidence.
>   

I suspect that the drive is simply choking on the barrier related cache 
flushing that we do - that seemed to be the MacOS error as well. The 
windows comment suggested that windows had an hba/driver bug (most 
likely unrelated to this).

If you want to avoid the issue until they fix the drive, you could run 
fast and dangerous (mount without barriers on) or slow and safe (disable 
the write cache).

>   
>>   "We already know about the Linux issue, it is indeed a kernel error
>>   causing the problem as it was explained to me by one of our developers."
>>     
>
> Well if they'd care to explain it to linux-ide perhaps we can find a work
> around. I would be cautious about disabling the write caching as it will
> harm both performance and probably drive lifetime.
>
> Alan
>   

This looks to me to be a drive firmware issue. I would wait until 
someone can test with their announced firmware upgrade before looking at 
the kernel :-)

ric




