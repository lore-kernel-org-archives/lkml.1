Return-Path: <linux-kernel-owner+w=401wt.eu-S1754626AbYKCGgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbYKCGgA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 01:36:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbYKCGfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 01:35:50 -0500
Received: from kuber.nabble.com ([216.139.236.158]:45312 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbYKCGfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 01:35:50 -0500
Message-ID: <20297895.post@talk.nabble.com>
Date: Sun, 2 Nov 2008 22:35:49 -0800 (PST)
From: peter360 <peter360@fastmail.us>
To: linux-kernel@vger.kernel.org
Subject: Re: which .ko file?
In-Reply-To: <490E87A8.8020600@alcatel-lucent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: peter360@fastmail.us
References: <20297391.post@talk.nabble.com> <490E87A8.8020600@alcatel-lucent.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


thanks for the quick reply.  You are right.  I did what you suggested, and
rebooted the computer, now 'lsmod | grep 3945' is not showing anything.


gshan wrote:
> 
> peter360 wrote:
>> Hi,
>>
>> How do I determine the .ko file used for a certain kernel module in a
>> running kernel?  For example, on my dell laptop I see
>> $ lsmod | grep 3945
>> ipw3945               230952  1 
>> ieee80211              65161  1 ipw3945
>>
>> $ modinfo ipw3945
>> modinfo: could not open /lib/modules/2.6.18-92.1.1.el5/extra/ipw3945.ko:
>> No
>> such file or directory
>>
>> $ locate ipw3945.ko
>> /lib/modules/2.6.18-52.el5/weak-updates/ipw3945.ko
>> /lib/modules/2.6.18-52.el5/weak-updates/ipw3945/ipw3945.ko
>> /lib/modules/2.6.18-8.1.4.el5/extra/ipw3945/ipw3945.ko
>> /lib/modules/2.6.18-92.1.1.el5/weak-updates/ipw3945/ipw3945.ko
>> /lib/modules/2.6.18-92.1.10.el5/weak-updates/ipw3945.ko
>> /lib/modules/2.6.18-92.1.10.el5/weak-updates/ipw3945/ipw3945.ko
>>
>> $ uname -a
>> Linux mylaptop 2.6.18-92.1.1.el5 #1 SMP Thu May 22 09:01:47 EDT 2008
>> x86_64
>> x86_64 x86_64 GNU/Linux
>>
>> How do I find out which ipw3945.ko file was actually loaded into the
>> kernel?
>> thanks!
>>   
> I think it's 
> /lib/modules/2.6.18-92.1.1.el5/weak-updates/ipw3945/ipw3945.ko, which
> matches your kernel version, right? You could remove it to another 
> directory instead
> of current used /lib/modules/2.6.18-92.1.1.el5/, then try "lsmod | grep 
> 3495". If you
> still could see it, then my guess is wrong. Otherwise, I'm correct.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 





-- 
View this message in context: http://www.nabble.com/which-.ko-file--tp20297391p20297895.html
Sent from the linux-kernel mailing list archive at Nabble.com.

