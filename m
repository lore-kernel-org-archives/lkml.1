Return-Path: <linux-kernel-owner+w=401wt.eu-S1756517AbYAPROP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517AbYAPROP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 12:14:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756552AbYAPRMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 12:12:09 -0500
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:34825 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757287AbYAPRMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 12:12:07 -0500
Date: Wed, 16 Jan 2008 22:41:34 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: "Renato S. Yamane" <renatoyamane@mandic.com.br>
Cc: Ray Lee <ray-lk@madrabbit.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Updatedb hangs Kernel 2.6.22.9-cfs-v22
Message-ID: <20080116171134.GA20063@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <478900FF.2000706@mandic.com.br> <2c0942db0801121025h7f22d716s657af75ce7603af0@mail.gmail.com> <478B7F9F.3020209@mandic.com.br> <2c0942db0801160830j72c0fc77xc4cc9e7fd676d78a@mail.gmail.com> <478E3395.6050301@mandic.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478E3395.6050301@mandic.com.br>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2008 at 02:40:53PM -0200, Renato S. Yamane wrote:
> Ray Lee escreveu:
>> On Jan 14, 2008 7:28 AM, Renato S. Yamane <renatoyamane@mandic.com.br> wrote:
>>> Ray Lee escreveu:
>>>> On Jan 12, 2008 10:03 AM, Renato S. Yamane wrote:
>>>>> I can't use updatedb in Debian Etch (stable) using customized Kernel
>>>>> 2.6.22.9-cfs-v22.
>>>>>
>>>>> When I ran updatedb, after ~1 minute my system hangs and "caps lock" LED
>>>>> is blinking. No log is registered.
>>>> Please switch out of X11 to a text mode console (CTRL-ALT-F1), and run
>>>> updatedb there. Capture the oops with a digital camera, and post a
>>>> link to the picture (not the picture itself!) to the list. Or, write
>>>> down the oops carefully, and post the text.
>>> I see a infinite loop and is very fast, so I can't capture errors messages.
>>> None is registered in /var/log/*
>>
>> Well, that's very odd. Please also try the latest CFS backport to see
>> if that solves the problem.
>
> This problem still occour in 2.6.23.13 with CFS 24.1
> I see a part of error message: Is something about ipw2200.
> I need find a Camera with good focus, because my cam is not so good to take 
> a picture in distance <=20cm.
>

Please see if you can reproduce it without the CFS backport.

[Please keep Ingo Molnar in the cc for CFS bugs, he is the maintainer.]

-- 
regards,
Dhaval
