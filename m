Return-Path: <linux-kernel-owner+w=401wt.eu-S1754478AbYLNPfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbYLNPfs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 10:35:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbYLNPfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 10:35:38 -0500
Received: from rv-out-0506.google.com ([209.85.198.228]:53579 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340AbYLNPfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 10:35:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:x-mailer:mime-version:subject:date:cc;
        b=pvrCNCjWmj1qTZZy5Ws9bg9xPbC722IiPwqBjErzdeIFSB/5SQ1752/FFVyjoZgl4F
         piP0XjCgHdicZrqEJaTvvucnob6IRAk/oWTRS+GTTmObUUdxkvYL7ynfLAaHBVh7+RjN
         rE51MMvOZx5GqB7fZ5M7UZ3Yv3CZ9R5tSC8K0=
References: <20081214031659.4b700a2d@liberty.rlwhome.lan> <1229263715.330.29.camel@pc.interlinx.bc.ca>
Message-Id: <9695C60B-CC91-41B3-87BB-D687E764BE30@gmail.com>
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
In-Reply-To: <1229263715.330.29.camel@pc.interlinx.bc.ca>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (5G77)
Mime-Version: 1.0 (iPhone Mail 5G77)
Subject: Re: suspend/resume fails on second attempt in LNXVIDEO:00
Date: Sun, 14 Dec 2008 07:35:21 -0800
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there quite possibly another
Graphics module you can plug-in,
Just to see

justin P. Mattock



On Dec 14, 2008, at 6:08 AM, "Brian J. Murrell"  
<brian@interlinx.bc.ca> wrote:

> On Sun, 2008-12-14 at 03:16 -0600, Robby Workman wrote:
>> In linux.kernel, Brian J. Murrell wrote:
>>> I'm trying to debug a resume problem on a compaq presario C700  
>>> laptop
>>> on the Ubuntu 2.6.24-22-generic kernel.
>>>
>>> SNIPPED
>>>
>>> These symptoms mirror a lot of other reports with this machine in  
>>> that
>>> the first suspend/resume cycle works but a second attempts
>>> (apparently) suspends fine but fails on resume.  The backlight on  
>>> the
>>> video does not come back and neither does the wireless connection,  
>>> so
>>> I'm not positive the problems are purely video related.
>>>
>>> How can I proceed from here to further debug what kind of  
>>> workarounds
>>> or solutions I might be able to use to get reliable suspend/resume
>>> functionality?
>>
>>
>> Assuming Ubuntu uses pm-utils for suspend/hibernate operations,  
>> then I
>> suspect you're needing this patch - the symptoms fit (suspend works
>> the first time, but fails thereafter), especially if a reboot causes
>> suspend to work fine again the first time...
>>
>> http://cgit.freedesktop.org/pm-utils/commit/?id=6c9f2959a36e608e4d1f71230a9eaaa77940c54e
>
> I wish (and was hoping) it was that simple.  The problem is the nature
> of that patch really has no effect on my system because $acpi_flag  
> == 0
> when the sysctl on line 147 is applied.  Presumably this patch has  
> more
> effect if $acpi_flag != 0, by nature of either $QUIRK_S3_BIOS or
> $QUIRK_S3_MODE being == true, neither of which is in my case.  Maybe  
> one
> or both should be.  I dunno.  I'm not sure how these "video quirks"
> work.
>
> b.
>
