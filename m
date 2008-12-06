Return-Path: <linux-kernel-owner+w=401wt.eu-S1753541AbYLFVnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbYLFVnf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 16:43:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbYLFVn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 16:43:26 -0500
Received: from mail-gx0-f29.google.com ([209.85.217.29]:61463 "EHLO
	mail-gx0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797AbYLFVn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 16:43:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=FDpWSm7wx+othU0tpnHM82fVT5X9ZRRB64w2u8R807NXAgHrDgDYsNBUvel1LlVb2I
         pKr7PLQQeR30Q0NiLgwtE7s2BjKG6+Z5eSr4ayv+txn5so5gtsO9Jxd725RiQiP3hs/M
         c2UP8yW19bV+02oCcJW4wZBcj6NBBfqxu4QSU=
Message-ID: <12bfabe40812061343j400f55d8r43571c8bd514adde@mail.gmail.com>
Date: Sat, 6 Dec 2008 22:43:24 +0100
From: "Giangiacomo Mariotti" <gg.mariotti@gmail.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Subject: Re: [HW PROBLEM] Intel I7 MCE. Erratum or not?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <493AE770.5030507@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12bfabe40812060421j10c93b3dg75a48aa304f633e8@mail.gmail.com>
	 <493AE770.5030507@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 6, 2008 at 9:58 PM, Robert Hancock <hancockr@shaw.ca> wrote:
> Giangiacomo Mariotti wrote:
>>
>> Hi everyone,
>> Mcelog just logged on my new Intel I7 920 (on Linux 2.6.27.8) this :
>> MCE 0
>> HARDWARE ERROR. This is *NOT* a software problem!
>> Please contact your hardware vendor
>> CPU 0 BANK 6 MISC 202d ADDR ffeef740
>> MCG status:
>> MCi status:
>> Error overflow
>> Uncorrected error
>> MCi_MISC register valid
>> MCi_ADDR register valid
>> Processor context corrupt
>> MCA: Generic CACHE Level-2 Data-Write Error
>> STATUS ee0000000100014a MCGSTATUS 0
>>
>> I'm reporting this here, because I found in the Intel I7 Technical
>> Specification November 2008 update that something which seems very
>> similar is in fact an erratum. So my question is : Is there any way
>> for me to verify that my problem is due to one of those errata,instead
>> of a broken hardware(if we don't want to consider all those errata as
>> broken hardware)? I'm also reporting this because I thought it may be
>> useful to signal that(if actually due to those errata) these problems
>> actually occur, so it may be useful to find workarounds in the kernel
>> to not scare to death poor Linux users!
>
> Which erratum are you talking about? I don't see one in that document that
> would match this case..
>
Well, the first one seems very similar, even if it talks about a dtlb
error instead of cache error. But sure,being similar doesn't mean too
much. Number 52 seems similar too. I guess I should just give up and
admit that my hardware is broken!
