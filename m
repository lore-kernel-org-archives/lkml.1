Return-Path: <linux-kernel-owner+w=401wt.eu-S932195AbXAWIcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195AbXAWIcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 03:32:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932412AbXAWIcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 03:32:16 -0500
Received: from server077.de-nserver.de ([62.27.12.245]:39158 "EHLO
	server077.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932195AbXAWIcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 03:32:15 -0500
Message-ID: <45B5C7FA.1020508@profihost.com>
Date: Tue, 23 Jan 2007 09:31:54 +0100
From: Stefan Priebe - FH <studium@profihost.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: XFS or Kernel Problem / Bug
References: <20060801143803.E2326184@wobbly.melbourne.sgi.com> <44CF36FB.6070606@profihost.com> <20060802090915.C2344877@wobbly.melbourne.sgi.com> <44D07AB7.3020409@profihost.com> <20060802201805.A2360409@wobbly.melbourne.sgi.com> <45B35CD7.4080801@profihost.com> <20070122061852.GT33919298@melbourne.sgi.com> <45B46CEE.4090808@profihost.com> <20070122080306.GW33919298@melbourne.sgi.com> <45B470BB.8000208@profihost.com> <20070123011052.GD33919298@melbourne.sgi.com>
In-Reply-To: <20070123011052.GD33919298@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by hostmaster@profihost.com through 84.134.57.107
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I can give you an idea of the workload :-) I have the same problem on an 
nearly idle Server. There runs only a few cronjobs (normal Debian System 
crons).

The load was not higher than 0.01 on this system the last 3 days and 
this morning it crashes with the same error.

I've not tested 2.6.19.x cause this one has some problems with SATA AHCI 
driver which we need. But i can manuelly update only this system with 
2.6.19.x and wait some days.

There were no other messages in the log.

Cheers,
    Stefan

David Chinner schrieb:
> On Mon, Jan 22, 2007 at 09:07:23AM +0100, Stefan Priebe - FH wrote:
>> Hi!
>>
>> The update of the IDE layer was in 2.6.19. I don't think it is a 
>> hardware bug cause all these 5 machines runs fine since a few years with 
>> 2.6.16.X and before. We switch to 2.6.18.6 on monday last week and all 
>> machines began to crash periodically. On friday last week we downgraded 
>> them all to 2.6.16.37 and all 5 machines runs fine again. So i don't 
>> believe it is a hardware problem. Do you really think that could be?
> 
> I was thinking more of a driver change that is being triggered on
> that particular hardware. FWIW, did you test 2.6.19?
> 
> I really need a better idea of the workload these servers are running
> and, ideally, a reproducable test case to track something like
> this down. At the moment I have no idea what is going on and no
> real information on which to even base a guess.
> 
> Were there any other messages in the log?
> 
> On Mon, Jan 22, 2007 at 10:42:36AM +0100, Stefan Priebe - FH wrote:
>> Hi!
>>
>> I've another idea... could it be, that it is a barrier problem? Since 
>> barriers are enabled by default from 2.6.17 on ...
> 
> You could try turning it off. If it does fix the problem, then I'd be
> pointing once again at hardware ;)
> 
> Cheers,
> 
> Dave.

