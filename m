Return-Path: <linux-kernel-owner+w=401wt.eu-S1752506AbYIBLUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbYIBLUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 07:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751113AbYIBLUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 07:20:09 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:41052 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178AbYIBLUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 07:20:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Received:Message-ID:In-Reply-To:References:Date:Subject:From:To:Cc:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:Importance;
	b=QpiPhMlSVouHhfRe0t7kf2vtDYxm25FumzU41auvgoH79eBXxgo9wmNNPrZsVMOVVbodHwtQWVA+RP1jwalysI2sHDTmylB4srKULjU5NYKEQPe4JEVn73MwPwdujefG;
Message-ID: <d557139bacb2f079787b50f684b2aea8cd6988af@8b5064a13e22126c1b9329f0dc35b8915774b7c3.invalid>
In-Reply-To: <20080902080728.GD15399@elf.ucw.cz>
References: <48977AF7.2070300@simon.arlott.org.uk>
    <20080808071430.GA10370@ucw.cz>
    <21f16315cade48d9ecdc87a25b769b9f310fa112@8b5064a13e22126c1b9329f0dc35b8915774b7c3.invalid>
    <489DACCE.7050000@simon.arlott.org.uk>
    <20080812103143.GD2641@elf.ucw.cz>
    <48B03F0E.9060605@simon.arlott.org.uk>
    <20080902080728.GD15399@elf.ucw.cz>
Date: Tue, 2 Sep 2008 12:20:00 +0100
Subject: Re: [linux-pm] Tyan S2923-E suspend to ram fails to resume
From: "Simon Arlott" <simon@fire.lp0.eu>
To: "Pavel Machek" <pavel@suse.cz>
Cc: linux-pm@lists.linux-foundation.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.10a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, September 2, 2008 09:07, Pavel Machek wrote:
> On Sat 2008-08-23 17:47:10, Simon Arlott wrote:
>> On 12/08/08 11:31, Pavel Machek wrote:
>>> Yep, that should work. When it does not, it means BIOS is not
>>> returning to our real mode code :-(. You may want to try disabling
>>> APIC and similar stuff, in hope of working around BIOS bug you are
>>> hitting, but ...
>>
>> I've tried the simplest possible 32-bit UP kernel I could come up with
>> (.config attached) and it still doesn't work.
>>
>> (I modified post_init() to call pm_suspend(PM_SUSPEND_MEM).)
>>
>> Disassembly of the BIOS shows that DE is indeed part of 0xDEAD, but I
>> haven't been able to tell what it's doing between D0 and there... not all
>> of the port 80 codes that are displayed are easily visible.
>>
>> I've tried disabling all the CPU options in the BIOS, e.g. microcode
>> update, VM, NMI but it doesn't help. I'm wondering if D0 is the right start
>> point for the system - there's a DC code for S3 resume:
>
> ...you did a lot of work, but these issues are hard.
>
> Do Windows suspend/resume on same hardware? BSD?

Tyan is going to look into it based them being able to use a common Linux
system (Knoppix 5.1.1) that fails to resume for me.

I've tried Windows XP 64-bit SP2C, that will only go to S1.
Vista Ultimate 64-bit will only go to S1 too.

I've yet to try a BSD, but it'll be a couple of weeks before I can do
that.

-- 
Simon Arlott
