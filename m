Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab0BNIjB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 03:39:01 -0500
Received: from mail-pz0-f197.google.com ([209.85.222.197]:50234 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab0BNIi7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 03:38:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qkSP1qsdtRQ89wfHQb9P1/uA/w1NZBe5CxqMOa6Qd+pJSlgWUgtU9dQvCNCjdGOuwo
         BkREX6WpdxGf2s/poHCefwDTGGxh8jw8FzYkaHEunSFDlYvfHIrjCOIulXTO3wogT4Cn
         o/Le22ex509lawHhPypheylr3aGTCg8faX8Uc=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1002132320320.5135@asgard.lang.hm>
References: <201002140251.59668.volkerarmin@googlemail.com>
	 <4877c76c1002132002s20d942c3i7cee5418cdcf369c@mail.gmail.com>
	 <alpine.DEB.2.00.1002132320320.5135@asgard.lang.hm>
Date: Sun, 14 Feb 2010 00:38:58 -0800
Message-ID: <4877c76c1002140038p4a7d8d75r3bc9d615b0e68199@mail.gmail.com>
Subject: Re: Linux mdadm superblock question.
From: Michael Evans <mjevans1983@gmail.com>
To: david@lang.hm
Cc: Volker Armin Hemmann <volkerarmin@googlemail.com>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 13, 2010 at 11:21 PM,  <david@lang.hm> wrote:
> On Sat, 13 Feb 2010, Michael Evans wrote:
>
>> On Sat, Feb 13, 2010 at 5:51 PM, Volker Armin Hemmann
>> <volkerarmin@googlemail.com> wrote:
>>>>
>>>> 0.90 has a very bad problem, which is that it is hard to distinguish
>>>> between a RAID partition at the end of volume and a full RAID device.
>>>> This is because 0.90 doesn't actually tell you the start of the device.
>>>>
>>>> Then, of course, there are a lot of limitations on size, number of
>>>> devices, and so on in 0.90.
>>>
>>> but it is the only format supporting autodetection.
>>>
>>> So - when will autodetection be introduced with 1.X? And if not, why not?
>>>
>>> All I found was 'autodetection might be troublesome' and nothing else.
>>>  But dealing with initrds is troublesome too. Pure evil even.
>>>
>>> Gl?ck Auf,
>>> Volker
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>> I remember hearing that 1.x had /no/ plans for kernel level
>> auto-detection ever.  That can be accomplished in early-userspace
>> leaving the code in the kernel much less complex, and therefore far
>> more reliable.
>>
>> In other words, 'auto-detection' for 1.x format devices is using an
>> initrd/initramfs.
>
> hmm, I've used 1.x formats without an initrd/initramfs (and without any
> conifg file on the server) and have had no problem with them being
> discovered. I haven't tried to use one for a boot/root device, so that may
> be the difference.
>
> David Lang

Yes, that is the difference.  You must have a more traditional simple
block device and filesystem drivers compiled in.  You have no need for
extra drivers or higher level device detection and evaluation (with
user-set policies to determine operation).  Anything past root-fs
mount can happen in normal user-space before logins are enabled.
