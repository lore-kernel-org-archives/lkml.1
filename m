Return-Path: <linux-kernel-owner+w=401wt.eu-S1759449AbYAYSzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759449AbYAYSzl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 13:55:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755915AbYAYSze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 13:55:34 -0500
Received: from gw.goop.org ([64.81.55.164]:38763 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755829AbYAYSzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 13:55:33 -0500
Message-ID: <479A30A3.7050305@goop.org>
Date: Fri, 25 Jan 2008 10:55:31 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Yinghai Lu <Yinghai.Lu@Sun.COM>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: trim ram need to check if mtrr is there v3
References: <47993F1A.5070408@goop.org> <200801241947.55223.yinghai.lu@sun.com> <4799930B.40006@goop.org> <200801250042.53074.yinghai.lu@sun.com> <20080125110935.GA20026@elte.hu>
In-Reply-To: <20080125110935.GA20026@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
>
>   
>> [PATCH] x86: trim ram need to check if mtrr is there v3
>>     
>
>   
>>> H. Peter Anvin wrote:
>>> Looks like the code doesn't check that the CPU *has* MTRRs...
>>>       
>> so more strict check if mtrr is there really.
>> bail out if mtrr all blank when qemu cpu model is used
>>
>> and check if is AMD as early
>> also remove 4G less check, according to hpa.
>>     
>
> thanks, applied. Shouldnt we put in an exception for when there is MTRR 
> support, but they dont cover anything. Still emit a warning - but 
> booting up real slow is still better than losing all of RAM and crashing 
>   

The problem is re-occuring for me with current x86.git.  Looks like v2 
did the trick, and v3 is broken...

    J
