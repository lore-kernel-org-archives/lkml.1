Return-Path: <linux-kernel-owner+w=401wt.eu-S936778AbYGCHPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936778AbYGCHPG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:15:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755344AbYGCG66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:58:58 -0400
Received: from smtp-out-2.talktalk.net ([62.24.128.232]:9515 "EHLO
	smtp.talktalk.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755390AbYGCGoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 02:44:23 -0400
X-Path: TTSMTP
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgotAIcSbEhZ8m2EPGdsb2JhbACSOgEBAQEtnwk
Date: Thu, 3 Jul 2008 07:44:08 +0100 (BST)
From: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
X-X-Sender: tigran@ginsburg.homenet
To: Valdis.Kletnieks@vt.edu
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: Intel Microcode loader, tg3 driver, and the -rc8-mmotd New World
 Order firmware...
In-Reply-To: <32146.1215066947@turing-police.cc.vt.edu>
Message-ID: <Pine.LNX.4.61.0807030743230.10608@ginsburg.homenet>
References: <4534.1215048758@turing-police.cc.vt.edu>           
 <Pine.LNX.4.61.0807030716030.10434@ginsburg.homenet> <32146.1215066947@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jul 2008 Valdis.Kletnieks@vt.edu wrote:

> On Thu, 03 Jul 2008 07:17:16 BST, Tigran Aivazian said:
>> Hi Valdis,
>>
>> On Wed, 2 Jul 2008 Valdis.Kletnieks@vt.edu wrote:
>>
>>> I built the -rc8-mmotd kernel, and built it with 'CONFIG_FIRMWARE_IN_KERNEL
> =n'.
>>> Lo and behold, the microcode.ko was now doing a request_firmware for
>>> 'intel-ucode/06-0f-06' (which makes sense, the Core2 Duo in this laptop is
>>> family 6, model 15, stepping 6).  However, what I had in /lib/firmware was
>>> the Intel-distributed 'microcode.dat' with updates for all the CPUs (which
>>> used to work in times past).
>>>
>>> What's the magic incantation to take the microcode.dat and create something
>>> that the firmware driver is willing to use, or is this all borked up and
>>> I need to do a major rethink or fix my config?
>>
>> that's because it expects the Intel-supplied microcode data and you are
>> using the old style microcode.dat data.
>
> I fed it the stuff I downloaded today from this URL:
>
> http://downloadcenter.intel.com/filter_results.aspx?strTypes=all&ProductID=2643&OSFullName=Linux*&lang=eng&strOSs=39&submit=Go!
>
> which gets me a microcode-20080401.dat that does the same thing.  Is there
> some *other* Intel-supplied microcode data I should be getting instead?

Oh, sorry, I assumed that Intel distribute the data in the format that 
driver expects.

Kind regards
Tigran
