Return-Path: <linux-kernel-owner+w=401wt.eu-S1757594AbXFOTGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594AbXFOTGf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 15:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbXFOTG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 15:06:28 -0400
Received: from smtp1.libero.it ([193.70.192.51]:58676 "EHLO smtp1.libero.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195AbXFOTG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 15:06:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAAALN/ckaXSMuO/2dsb2JhbAAN
Message-ID: <4672E35D.1060303@gmail.com>
Date: Fri, 15 Jun 2007 21:07:09 +0200
From: Davide Nitti <davidenitti@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Carlo Wood <carlo@alinoe.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Random X lockup
References: <4671AF64.9050201@gmail.com> <9a8748490706141552l6d112c16tc306784664c6504d@mail.gmail.com> <46728BB6.4040704@gmail.com> <20070615142809.GD11830@alinoe.com>
In-Reply-To: <20070615142809.GD11830@alinoe.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I will try to compile X in debug mode, so I will have more info while debug.
(how I read in 
http://xorg.freedesktop.org/wiki/Development/Documentation/ServerDebugging)

I have this problem only with a pc in others pc i haven't this problem,
but windows don't crash, so I guess that isn't a bad hardware problem.

> On the other hand - if you had this 'freeze' with
> with many different kernel versions, and different xorg
> versions and different video cards etc etc - then realize

I tried only 1 hardware configuration, trying several software configuration
others people have my problem with different hardware configuration

I have read many forums related to the problem
(such as 
http://forums.gentoo.org/viewtopic-t-198023-postdays-0-postorder-asc-highlight-lockups-start-0.html)
I have this problem since years such as many others people in the world 
(reading in internet)

Carlo Wood ha scritto:
> On Fri, Jun 15, 2007 at 02:53:10PM +0200, davide wrote:
>   
>> (gdb) bt
>> #0  0xb7fa9800 in firegl_PM4WaitForIdle ()
>>    from /usr/lib/xorg/modules/linux//libfglrxdrm.so
>> #1  0xb799ee11 in atiddxAccelCPWaitForIdle ()
>>    from /usr/lib/xorg/modules//drivers/fglrx_drv.so
>> #2  0xb7726452 in XAACopyAreaFallback () from
>> /usr/lib/xorg/modules//libxaa.so
>> #3  0xb77276a7 in XAACopyArea () from /usr/lib/xorg/modules//libxaa.so
>> #4  0x0808460a in ProcCopyArea ()
>> #5  0x0813d621 in XaceCatchDispatchProc ()
>> #6  0x0808643f in Dispatch ()
>> #7  0x0806e885 in main ()
>> (gdb) cont
>> Continuing.
>>     
>
> Is there only one thread running?
> I guess that if you want to debug this, you'll have to
> compile xorg from source - so you can actually see what
> it's doing in that function.
>
> On the other hand - if you had this 'freeze' with
> with many different kernel versions, and different xorg
> versions and different video cards etc etc - then realize
> that for MOST people it all works perfectly; therefore
> it's a large chance that whatever is constant in your
> setup is the problem: your hardware. Or, maybe you didn't
> try a different videocard (still hardware), or it's
> closed source driver...
>
> After reading your first post I thought: man replace your
> hardware already. But if the machine doesn't lock up - just
> X - then it could certainly be a software problem, I guess.
>
> I doubt this is related to the kernel however.
>
>   
