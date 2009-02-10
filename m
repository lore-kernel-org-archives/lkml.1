Return-Path: <linux-kernel-owner+w=401wt.eu-S1757328AbZBJXW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328AbZBJXW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 18:22:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756209AbZBJXWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 18:22:21 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:15176 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041AbZBJXWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 18:22:20 -0500
X-Spam-Flag: NO
X-Spam-Score: -12.589
Message-ID: <49920C24.5070804@tremplin-utc.net>
Date: Wed, 11 Feb 2009 00:22:12 +0100
From: =?ISO-8859-1?Q?=C9ric_Piel?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20081231 Mandriva/2.0.0.19-1mdv2009.1 (2009.1) Thunderbird/2.0.0.19 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>, pavel@suse.cz,
       linux-kernel@vger.kernel.org, palatis@gmail.com
Subject: Re: [PATCH] lis3lv02d: add axes knowledge of HP Pavilion dv5 models
References: <1233967681-6378-1-git-send-email-giuseppe.bilotta@gmail.com>	<498D9F02.9000107@tremplin-utc.net>	<cb7bb73a0902071559w70b3367el9471db894872257f@mail.gmail.com>	<20090209094748.GC4358@atrey.karlin.mff.cuni.cz>	<cb7bb73a0902090153q30a5337bj45d41a3e3919e189@mail.gmail.com>	<20090209095803.GD4358@atrey.karlin.mff.cuni.cz>	<cb7bb73a0902090345y4ef5d544ta374ee96791a80df@mail.gmail.com>	<cb7bb73a0902090533q3acc45b2r7d00b44aa0bdfc90@mail.gmail.com>	<20090210101019.GB27018@atrey.karlin.mff.cuni.cz>	<cb7bb73a0902101339g351bdd8cq442bafbeb7985a00@mail.gmail.com>	<cb7bb73a0902101448h74b6b73j8307c65c4f006152@mail.gmail.com> <20090210151718.4a8f3421.akpm@linux-foundation.org>
In-Reply-To: <20090210151718.4a8f3421.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton schreef:
> On Tue, 10 Feb 2009 23:48:14 +0100
> Giuseppe Bilotta <giuseppe.bilotta@gmail.com> wrote:
> 
>> On Tue, Feb 10, 2009 at 10:39 PM, Giuseppe Bilotta
>> <giuseppe.bilotta@gmail.com> wrote:
>>> On Tue, Feb 10, 2009 at 11:10 AM, Pavel Machek <pavel@suse.cz> wrote:
>>>> Yeah, that patch. Not sure what to do next... you could grab lis3
>>>> manual and see if you can setup chip by hand to get better results...
>>> As Eric pointed out, it looks definitely like an endianness problem,
>>> although there are a few strange things which are happening at the
>>> same time. Is the lis3 manual available online somewhere, or can I
>>> request it to the mfgr?
>> 'k, found it on the STMicroelectronics website. Reading the doc about
>> LIS3LV02DL I see that WHO_AM_I should return 3Ah, but my sensor
>> returns 3Bh. I'll see if I find the correct datasheet for this one
>> instead, it might have info about the differences.
>>
>> One thing that I noticed is that (modulo axis inversion) I'm able to
>> use the sensor correctly if I set the thing to only use the high byte,
>> totally discarding the lower byte:
>> 	return *((s8*)(&hi));
>> Maybe this sensor needs a different setup to return 12 instead of 8
>> bits of information.
>>
> 
> I've lost the plot here.  I still intend to merge
> lis3lv02d-add-axes-knowledge-of-hp-pavilion-dv5-models.patch into
> 2.6.29.  Someone please stop me if that is wrong.
Hi Andrew,
No, let's wait to get things settle down. You can discard the current 
patch. I think we should manage to get it working eventually, but the 
patch will be much bigger...

Eric
