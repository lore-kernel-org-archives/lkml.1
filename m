Return-Path: <linux-kernel-owner+w=401wt.eu-S1758242AbZDSTcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbZDSTcd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 15:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756049AbZDSTcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 15:32:23 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:26656 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755981AbZDSTcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 15:32:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:mime-version:subject:date:references
         :x-mailer;
        b=xvFgML4poWi2uPwKAUa+OMdAmcwBLGMPQVZYqBwMIPpQ/5hM2NxFauQCq0fmGT5yn7
         jkwpch4ogUT7LHrorQt0CuAE8USXNXsq1Q9IY4+4ddWsWnO5s1fZBHEapev+6II9i0oz
         lT10sKTuuZzz0EPQlWnlgkU61YlWgPMd6NuzY=
Message-Id: <8AF7B5C5-FC88-443C-98BF-007E080B478E@gmail.com>
From: Robert Nicholson <robert.nicholson@gmail.com>
To: linux-kernel@vger.kernel.org
In-Reply-To: <C2111E25-C51B-4AB1-96F5-A7C313B4B487@gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: Does the linux kernel contain support for ATA Security feature set?
Date: Sun, 19 Apr 2009 14:32:16 -0500
References: <CC1C24F4-B448-4453-BA6C-EF436231B267@gmail.com> <20090417004633.GB869@srcf.ucam.org> <C2111E25-C51B-4AB1-96F5-A7C313B4B487@gmail.com>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So when I do a hdparm --security-set-pass NULL /dev/sda

I get a

SECURITY_ERASE: Input/output error

This is with a kernel that doesn't have CONFIG_IDE_TASK_IOCTL=y defined

I'm also told that for SATA drives that's not necessary anyway. Is  
that correct?

What should the response be for hdparm if CONFIG_IDE_TASK_IOCTL isn't  
defined for a drive that needs it?

The drive is an Intel X-25M

HDDERASE won't work since I'm on a Mac.

I don't want to create a customized lived CD witth a new kernel unless  
it's necessary.

On Apr 16, 2009, at 7:50 PM, Robert Nicholson wrote:

> So you're implying that it is possible to do a SECURE_ERASE using  
> hdparm then.
>
> I don't know why but HDDERASE tool requires legacy IDE mode.
>
> On Apr 16, 2009, at 7:46 PM, Matthew Garrett wrote:
>
>> On Thu, Apr 16, 2009 at 06:49:59PM -0500, Robert Nicholson wrote:
>>> So, I've got an X-25M that I want to securely erase and it turns out
>>> on a Mac I'm not going to be able to issue the command because it
>>> doesn't support legacy IDE mode from what I understand. So the  
>>> idea of
>>> a any boot CD that I could boot and run a program that can issue a
>>> SECURE_ERASE (SE) to the drive is only applicable to PC's.
>>
>> Why is the lack of legacy IDE an issue? hdparm works fine with SATA
>> setups.
>> -- 
>> Matthew Garrett | mjg59@srcf.ucam.org
>

