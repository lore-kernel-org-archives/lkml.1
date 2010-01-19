Return-Path: <linux-kernel-owner+w=401wt.eu-S1753268Ab0ASOce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab0ASOce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 09:32:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926Ab0ASOcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 09:32:32 -0500
Received: from mail-pz0-f190.google.com ([209.85.222.190]:44213 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab0ASOca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 09:32:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=faX/M19/Z7MAieCL998ZGp/u9Evf+r7dTYgQE/opDp+yy1ygrgOTtSobBTiAU9N+rI
         Tmoov/HkaiKzfKk2q3AscB0yrlWvMX3ZowA/OXcF4Y//ox/XAH+MHRULtrkYsQ6d9MYh
         t+k5AEb+XW5z1bowzwIEShxlNLvPtpUB8SZ9s=
Date: Tue, 19 Jan 2010 22:34:13 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: jidong xiao <jidong.xiao@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: Where is proc_misc.c?
Message-ID: <20100119143413.GD3473@hack>
References: <4104961b1001182254x74f3fcd1r906de8f10c105f8a@mail.gmail.com> <4B5557A7.5000401@cn.fujitsu.com> <4104961b1001182334n7bd9c472r9689caf6b84788a2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4104961b1001182334n7bd9c472r9689caf6b84788a2@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 03:34:31PM +0800, jidong xiao wrote:
>On Tue, Jan 19, 2010 at 2:56 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>> jidong xiao wrote:
>>> Hi,
>>>
>>> Does anybody know what happend to fs/proc/proc_misc.c? The file is
>>> missing in 2.6.29. Seems like there was an cleanup, but i can't find
>>> the new location of the methods. Any help appreciated.
>>>
>>
>> $ git log -- fs/proc/proc_misc.c
>> commit 59c7572e82d69483a66eaa67b46548baeb69ecf4
>> Author: Alexey Dobriyan <adobriyan@gmail.com>
>> Date:   Mon Oct 6 14:49:39 2008 +0400
>>
>>    proc: remove fs/proc/proc_misc.c
>>
>>    Now that everything was moved to their more or less expected places,
>>    apply rm(1).
>>
>>    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
>>
>>
>
>Oh, I see. It looks like proc_misc.c has been splited into several
>files, such as cmdline.c,version.c,uptime.c,meminfo.c.Thank you.

Or you can use:

   git log --diff-filter=D fs/proc

-- 
Live like a child, think like the god.
 
