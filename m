Return-Path: <linux-kernel-owner+w=401wt.eu-S1751988AbZGRNqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbZGRNqK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 09:46:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbZGRNqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 09:46:09 -0400
Received: from mail.gmx.net ([213.165.64.20]:52728 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751845AbZGRNqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 09:46:08 -0400
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX1+f/W9KynufLbxsfm9ELBQ5H3TrGsGlEyofOCx7c2
	L7+8RAH+sL5XaH
Message-ID: <4A61D21E.2020808@fisher-privat.net>
Date: Sat, 18 Jul 2009 15:46:06 +0200
From: Alexey Fisher <bug-track@fisher-privat.net>
User-Agent: Thunderbird 2.0.0.22 (X11/20090710)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: PM: resume devices took 9.176 seconds
References: <4A52247B.4040204@fisher-privat.net> <20090718114913.GF1433@ucw.cz>
In-Reply-To: <20090718114913.GF1433@ucw.cz>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5600000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek schrieb:
> On Mon 2009-07-06 18:21:15, Alexey Fisher wrote:
>> Hallo all,
>> it testing a lot git tree especially suspend and resume. With my new  
>> Intel DG45ID board i get always this trace:
>>
>> ============================================
>> [  176.763922] PM: resume devices took 9.176 seconds
>> [  176.763924] ------------[ cut here ]------------
>> [  176.763930] WARNING: at kernel/power/suspend_test.c:52  
>> suspend_test_finish+0x7c/0x80()
>>
>> this is related with the commit:
>>    commit 77437fd4e61f87cc94d9314baa5cbf50e3ccdf54
>> Author: David Brownell <dbrownell@users.sourceforge.net>
>> Date:   Wed Jul 23 21:28:33 2008 -0700
>>
>> probobly it's depend  on this message:
>> [  173.076075] ata1: link is slow to respond, please be patient (ready=0)
>>
>> so it's looks normal for this board and harddrive. I think it should be  
>> some way to change default TEST_SUSPEND_SECONDS by .config or  
>> kernel-parameter. I changed default settings to 10 in  
>> kernel/power/suspend_test.c but this is not the way it should be done.
> 
> I'm not sure if that's normal. Does it also delay on boot?

I have same time with test_suspend=mem on boot and with normal suspend. 
Probably there is some thing wrong but it's seems for like it do the 
same in windows vista like in linux. In linux i use clean suspend... no 
distro scripts used... in dmesg i ken see that sata harddrive need some 
time to wake, so i think it's the reason for it.

