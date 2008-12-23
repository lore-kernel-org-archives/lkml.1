Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbYLWDE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbYLWDE5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 22:04:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752310AbYLWDEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 22:04:48 -0500
Received: from main.gmane.org ([80.91.229.2]:39876 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140AbYLWDEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 22:04:48 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: malc@pulsesoft.com
Subject: Re: Lock-up on PPC64
Date: Tue, 23 Dec 2008 06:04:45 +0300
Message-ID: <877i5rh9rm.fsf@linmac.oyster.ru>
References: <Pine.LNX.4.64.0812212058550.2164@linmac.oyster.ru> <20081222233223.GA6688@joi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 83.167.112.74
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
Cancel-Lock: sha1:R3EWNCJM4sGPJO8VwyJABNhADj8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcin Slusarz <marcin.slusarz@gmail.com> writes:

> On Sun, Dec 21, 2008 at 09:18:07PM +0300, malc wrote:
>> Plain/non-root userspace application which doesn't interface with
>> any weird out-of/in-tree drivers manages to lock-up a PS3 machine
>> running Linux.
>>
>> The application in question is Mono VM running mcs.exe (C# compiler)
>> which tries to compile particular file, distribution is Yellow Dog Linux
>> 6.0 with either stock (2.6.23.x) or custom compiled (2.6.27) 64bit kernel.
>>
>>
>> Symptoms are as follows (interaction is done via ssh from another
>> machine):
>>
>> $ make
>> ... lots of stdout/err messages
>> ... eventually an error message
>>
>> Eventually the ssh session terminates, PS3 is still pingable but
>> impossible to connect to, attaching keyboard and trying magic SysRq
>> doesn't work, typing keys into login: prompt works (as in - the terminal
>> shows keys that were pressed, but after hittiing enter the carret is
>> advanced and nothing happens, hitting random keys doesn't yield anything
>> either)
>
> Check your RAM first (memtest). If it won't find anything please post your
> config and dmesg. You can enable some debugging options ("Kernel hacking"
> in menuconfig), setup netconsole and see if it can catch anything.
> (see Documentation/networking/netconsole.txt)

I don't know where to get PPC64 capable memtest, even if it exists the
probability of two different machines exhibiting almost the same
behaviour is rather slim. Netconsole doesn't catch anything. In fact
i just had slightly different situation where after ssh connection was
killed i was able to reconnect and look at dmesg there - nothing.

-- 
mailto:av1474@comtv.ru

