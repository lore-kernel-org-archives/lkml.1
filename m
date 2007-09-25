Return-Path: <linux-kernel-owner+w=401wt.eu-S1759247AbXIYIHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247AbXIYIHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 04:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754963AbXIYIGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 04:06:44 -0400
Received: from p-mail2.rd.francetelecom.com ([195.101.245.16]:1502 "EHLO
	p-mail2.rd.francetelecom.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754901AbXIYIGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 04:06:40 -0400
Message-ID: <46F8C164.4080604@Free.fr>
Date: Tue, 25 Sep 2007 10:05:56 +0200
From: Eric Valette <Eric.Valette@Free.fr>
Reply-To: Eric.Valette@Free.fr
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: Rob Hussey <robjhussey@gmail.com>
CC: =?UTF-8?B?44Od44O844Or44O744Ot44Op44OzIFBhdWwgUm9sbGFuZA==?= 
	<rol@witbe.net>,
       flamingice@sourmilk.net, andreamrl@tiscali.it,
       linux-kernel@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
       torvalds@osdl.org
Subject: Re: rtl8187 driver in 2.6.23-rc6-git5: kernel panic if not used as
 a module. Works as a module.
References: <46EBE70C.2040201@free.fr> <46EBEBD2.7060502@free.fr>	 <6b8cef970709150928h25a7093md5f86d2bdcf677cc@mail.gmail.com>	 <46EC24B6.2030709@free.fr> <20070915185153.08490a9b@tux.DEF.witbe.net> <6b8cef970709151419r7561e950jcc35f4a50661273f@mail.gmail.com>
In-Reply-To: <6b8cef970709151419r7561e950jcc35f4a50661273f@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 25 Sep 2007 08:06:32.0003 (UTC) FILETIME=[FBC56930:01C7FF4A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Hussey wrote:
> On 9/15/07, ポール・ロラン Paul Rolland <rol@witbe.net> wrote:
>   
>> Hi Eric,
>>
>> On Sat, 15 Sep 2007 20:30:14 +0200
>> Eric Valette <eric.valette@free.fr> wrote:
>>
>>     
>>> Rob Hussey wrote:
>>>       
>>>> On 9/15/07, Eric Valette <eric.valette@free.fr> wrote:
>>>>         
>>>>> Eric Valette wrote:
>>>>>
>>>>>           
>>> Thanks for your help: it does indeed fix the problem.
>>>       
>> Nice it works for you too !
>>
>>     
>>> Now I have two side questions:
>>>       - the code is no more symetric "subsys_initcall" -> "module_exit".
>>> Do not know if it is "normal" but I love symmetry in code :-). Did not test
>>> it still works as a module...
>>>       
>> Symmetry is not broken, as we have :
>> #define subsys_initcall(fn)             module_init(fn)
>> in include/linux/init.h where compiling as a module, and when not compiling
>> as a module, I doubt the exit function is called unless you are shuting
>> down your machine...
>>
>>     
>>>       - Who takes the responsability to push a patch to Linus? I guess it
>>> is urgent unless he plans a rc7
>>>       
>> Good point ! I expect the patches to be already in some queue waiting to be
>> pulled !
>>     
>
> The patches are on their way to making it into 2.6.23:
> http://marc.info/?l=linux-netdev&m=118986368303529&w=2
>
> Regards,
> Rob
>   
I'm a little bit worried as rc8 is out and ots still not in git.

-- eric

