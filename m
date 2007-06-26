Return-Path: <linux-kernel-owner+w=401wt.eu-S1757230AbXFZMdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230AbXFZMdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 08:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752236AbXFZMdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 08:33:33 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:51992 "HELO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752046AbXFZMdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 08:33:32 -0400
Message-ID: <4681045D.2080105@aitel.hist.no>
Date: Tue, 26 Jun 2007 14:19:41 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Alberto Gonzalez <info@gnebu.es>
CC: Kyle Moffett <mrmacman_g4@mac.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Question about fair schedulers
References: <200706230007.15622.info@gnebu.es> <B6065113-E9C7-42CE-A43D-55E6BF1EE2C0@mac.com> <200706230946.44023.info@gnebu.es>
In-Reply-To: <200706230946.44023.info@gnebu.es>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alberto Gonzalez wrote:
> On Saturday 23 June 2007, Kyle Moffett wrote:
>   
>> On Jun 22, 2007, at 18:07:15, Alberto Gonzalez wrote:
>>     
>>> Ok, so what will a fair scheduler do in this case? It is my
>>> understanding that it would give 50% CPU to each task, resulting in
>>> the video dropping frames. Is this correct?
>>>       
>> Yes, that's correct.
>>
>> What this *actually* means is that you want the media player to have
>> higher priority than the DVD ripping program.  Ergo you should run
>> "nice +20 my_dvd_burner" or "nice +20 my_vorbis_encoder" under CFS or
>> other fair schedulers.
>>     
>
> Ok, that makes sense. The problem is that desktop users don't know about such 
> things, so the ideal situation would be that the scheduler knows about it and 
> does it for you.
>   
Well, the scheduler can't really know that.  But the people who
write the dvd burning/ripping/encoding/viewing software
know what is needed, they can write their programs so they set useful 
priorities.

Helge Hafting
