Return-Path: <linux-kernel-owner+w=401wt.eu-S1757963AbYJKPM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963AbYJKPM0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 11:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbYJKPMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 11:12:18 -0400
Received: from mail.tmr.com ([64.65.253.246]:50183 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181AbYJKPMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 11:12:18 -0400
Message-ID: <48F0C24E.9030205@tmr.com>
Date: Sat, 11 Oct 2008 11:12:14 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.17) Gecko/20080925 Fedora/1.1.12-1.fc9 SeaMonkey/1.1.12
MIME-Version: 1.0
To: Yudha Harimantoro T <yudha.ht@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: 
References: <264b990a0810110030r307829afmc8c2e1dfe6713faa@mail.gmail.com>
In-Reply-To: <264b990a0810110030r307829afmc8c2e1dfe6713faa@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yudha Harimantoro T wrote:
> Date:	Fri, 10 Oct 2008 16:41:36 -0400
> From:	Bill Davidsen
>
>
>   
>> Yudha Harimantoro T wrote:
>>     
>>> Hi all,
>>> Yesterday I build kernel 2.6.26.6 and it's run well. Today I got
>>> 2.6.27 patch and try to build it.
>>>
>>> I build with `make oldconfig` and answer any question with default answer, I just press [enter].
>>> I build with `make`. No error and all compiled.
>>> Then I install with `make modules_install` and `make install`.
>>>
>>>       
>
>   
>> I realize that this is a low-probability thought, but did you:
>> - apply the patch against 2.6.26 NOT 2.6.26.6
>>     
> Yup, I've did it.
>   
>> - run make clean before applying the patch
>>     
> I still need this for a pure 2.6.26? I'll try this.
>
>   
>>> After reboot the system I got 'kernel panic'.
>>> This is the error picture :
>>> http://www.ryht.co.cc/wordpress/wp-content/uploads/2008/10/pa101358.jpg
>>> Is it a bugs?
>>>
>>> http://www.ryht.co.cc/wordpress/wp-content/uploads/2008/10/pa101353.jpg [2.6.26.6 run well]
>>>       
>
>   
>> I keep configs in a separate place. I would first copy a 2.6.26 tree to a new directory (cp -rl linux-2.6.26 linux2.6.27) then be sure I had a clean copy with "make distclean" (or "make mrproper") and then apply the 2.6.27 patch. Then I would copy the 2.6.26 (or maybe 2.6.26.6) config to .config, and make the oldconfig.
>> None of that is magic, it just keeps me from making common mistakes, lets me start with a clean 2.6.27, etc, etc.
>> You mentioned oldconfig, but not starting back with a clean 2.6.26, which made me think of this.
>>     
> Hm, I `cp /boot/config .config` in new kernel tree [2.6.27] for the
> config. Do I make mistakes?
>   

No, I was just noting that I try to start oldconfig with a known working 
config, to reduce the number of choices and possible errors. I wasn't 
sure if you did that, so I mentioned it.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


