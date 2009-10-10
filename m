Return-Path: <linux-kernel-owner+w=401wt.eu-S934778AbZJJTdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934778AbZJJTdG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 15:33:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934750AbZJJTdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 15:33:04 -0400
Received: from web.keli.cz ([77.48.235.227]:40329 "EHLO web.keli.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932948AbZJJTdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 15:33:03 -0400
X-Greylist: delayed 1510 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Oct 2009 15:33:02 EDT
Message-ID: <4AD0DB52.20800@century.cz>
Date: Sat, 10 Oct 2009 21:06:58 +0200
From: =?ISO-8859-2?Q?Petr_Tit=ECra?= <P.Titera@century.cz>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Norbert Preining <preining@logic.at>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org
Subject: Re: complete IO hang since a few kernel revision
References: <20091005011626.GH4335@gamma.logic.tuwien.ac.at>	 <4AC9607D.6050900@datenparkplatz.de>	 <20091005083308.GB5612@gandalf.dynalias.org>	 <1254813111.6293.22.camel@marge.simson.net>	 <20091006071609.GB21772@gandalf.dynalias.org> <1254815060.8758.14.camel@marge.simson.net>
In-Reply-To: <1254815060.8758.14.camel@marge.simson.net>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith napsal(a):
> On Tue, 2009-10-06 at 16:16 +0900, Norbert Preining wrote:
>   
>> On Tue, 06 Oct 2009, Mike Galbraith wrote:
>>     
>>> I've tried unsuccessfully to reproduce this behavior.
>>>
>>> Since it doesn't appear to be something readily reproducible, more
>>> information and/or some digging on your part may be needed.
>>>       
>> Hm, how could I do that? I am fine with compiling some strange 
>> kernel options, or running some debugging task, but I don't have
>> and netconsole or serial console available.
>>     
>
> Locating when it started for you would be valuable, even if it's not
> pin-pointed such as a git bisection could do.  A bisection is the best
> bet to nail it down, but can be quite time consuming.
>
>   
I see something similar here. Processes just get stuck in 
balance_dirty_pages for infinite time. It helps if, when process is 
stuck another process generates some dirty pages. Unfotunately last 
kernel I'm prety sure everything worked is 2.6.31-rc9-tip-01355-ge035e96 
(yes its x86 -tip kernel). I'm building new kernel now.

Petr

> One thing you can try is to drop to a non-gui shell, and see it the
> symptom is reproducible without the GUI.  If it is, poke SysRq-W while
> things are thoroughly jammed up, and post the output+config here.
>
> 	-Mike
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
> __________ Informace od ESET Smart Security, verze databaze 4496 (20091010) __________
>
> Tuto zpravu proveril ESET Smart Security.
>
> http://www.eset.cz
>
>
>   



__________ Informace od ESET Smart Security, verze databaze 4496 (20091010) __________

Tuto zpravu proveril ESET Smart Security.

http://www.eset.cz


