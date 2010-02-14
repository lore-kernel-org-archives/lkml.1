Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab0BNHVz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 02:21:55 -0500
Received: from mail.lang.hm ([64.81.33.126]:40654 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348Ab0BNHVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 02:21:54 -0500
Date: Sat, 13 Feb 2010 23:21:52 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Michael Evans <mjevans1983@gmail.com>
cc: Volker Armin Hemmann <volkerarmin@googlemail.com>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: Linux mdadm superblock question.
In-Reply-To: <4877c76c1002132002s20d942c3i7cee5418cdcf369c@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1002132320320.5135@asgard.lang.hm>
References: <201002140251.59668.volkerarmin@googlemail.com> <4877c76c1002132002s20d942c3i7cee5418cdcf369c@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="680960-1867897933-1266132112=:5135"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--680960-1867897933-1266132112=:5135
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

On Sat, 13 Feb 2010, Michael Evans wrote:

> On Sat, Feb 13, 2010 at 5:51 PM, Volker Armin Hemmann
> <volkerarmin@googlemail.com> wrote:
>>> 0.90 has a very bad problem, which is that it is hard to distinguish
>>> between a RAID partition at the end of volume and a full RAID device.
>>> This is because 0.90 doesn't actually tell you the start of the device.
>>>
>>> Then, of course, there are a lot of limitations on size, number of
>>> devices, and so on in 0.90.
>>
>> but it is the only format supporting autodetection.
>>
>> So - when will autodetection be introduced with 1.X? And if not, why not?
>>
>> All I found was 'autodetection might be troublesome' and nothing else.
>>  But dealing with initrds is troublesome too. Pure evil even.
>>
>> Gl?ck Auf,
>> Volker
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> I remember hearing that 1.x had /no/ plans for kernel level
> auto-detection ever.  That can be accomplished in early-userspace
> leaving the code in the kernel much less complex, and therefore far
> more reliable.
>
> In other words, 'auto-detection' for 1.x format devices is using an
> initrd/initramfs.

hmm, I've used 1.x formats without an initrd/initramfs (and without any 
conifg file on the server) and have had no problem with them being 
discovered. I haven't tried to use one for a boot/root device, so that may 
be the difference.

David Lang
--680960-1867897933-1266132112=:5135--
