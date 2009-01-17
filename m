Return-Path: <linux-kernel-owner+w=401wt.eu-S1765605AbZAQD21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765605AbZAQD21 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 22:28:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751599AbZAQD2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 22:28:07 -0500
Received: from an-out-0708.google.com ([209.85.132.247]:53827 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbZAQD2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 22:28:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=TsKX+mj+dt6zmHNxpsFUYfrJ6vCnY+8CCeNT1N/+t15ChYXSKgsrybJ8rVaIMio0Wi
         N5Al33N2Rt+b22R6xN3GpLaKjACAnwXORGGdYB7sCCs9AKF21X/efIJ0SWMovKHpncX/
         y4Tg4eEJMi6q4JHI/E6xCBxmKqr3hRvvbKQtM=
Message-ID: <49715039.2090406@gmail.com>
Date: Fri, 16 Jan 2009 19:27:53 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Justin Madru <jdm64@gawab.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29-rc1 Firefox crashing on page load
References: <4970F46F.4060803@gawab.com> <49714266.6020401@gawab.com>
In-Reply-To: <49714266.6020401@gawab.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Madru wrote:
> Justin Madru wrote:
>> Hi,
>>
>> This is the weirdest crash I've come across related to an rc kernel.
>> First I tested .29-rc1 when it came out and firefox crashed only when 
>> clicking on certain links.
>> Now I updated my tree and compiled another kernel. This time firefox 
>> crashes right after it finishes loading my homepage.
>> This happens every time, and has never happened on any kernel before.
>>
>> I did a strace of firefox and these are the last few lines that are 
>> always present before it crashes:
>>
>> gettimeofday({1232129663, 344658}, NULL) = 0
>> gettimeofday({1232129663, 351300}, NULL) = 0
>> open(\"/home/justin/.mailcap\", O_RDONLY|O_LARGEFILE) = -1 ENOENT (No 
>> such file or directory)
>> time(NULL)                              = 1232129663
>> stat64(\"/home/justin/.gnome2/vfs/modules\", 0xbfec4efc) = -1 ENOENT 
>> (No such file or directory)
>> stat64(\"/etc/gnome-vfs-2.0/modules\", {st_mode=S_IFDIR|0755, 
>> st_size=128, ...}) = 0
>> geteuid32()                             = 1000
>> getegid32()                             = 1000
>> getuid32()                              = 1000
>> tgkill(4615, 4642, SIGRT_1upeek: ptrace(PTRACE_PEEKUSER,4615,44,0): 
>> No such process
>>
>> So far I've tried other programs, but I haven't seen any other crashes.
>> More information about my computer (including: dmesg, config, 
>> sysinfo) can be found at:
>> http://jdserver.homelinux.org/bugreports/
>>
>>
> I just tested on -rc2 and still firefox crashes upon finishing loading 
> the homepage.
> I've not had this problem with a pre-29 kernel.
>
> Justin Madru
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
I'm not seeing this with firefox over here.
The setup I have is the latest beta,
located in /usr/lib/firefox/ with a soft link to /usr/bin/
I don't have gnome2 vfs installed though.
just a bare firefox with 2 plugins(flash,null)
located in /.mozilla/plugins/
for restorecon.

not sure what distro you have, but with ubuntu
I noticed a quit a bit of other links created.
that is installing through apt-get, rather
just downloading the source and putting it wherever.

regards;

Justin P. Mattock
