Return-Path: <linux-kernel-owner+w=401wt.eu-S1761828AbZFRLnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761828AbZFRLnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 07:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761254AbZFRLm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 07:42:58 -0400
Received: from mail-fx0-f212.google.com ([209.85.220.212]:64843 "EHLO
	mail-fx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbZFRLm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 07:42:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=s/tTCNQ09F9b8J5sgajCata27JULTuop3zSZF0/39Ryocr3iSuWvSjw9EpmWk2UrXq
         mqBDaTD4qTlEqetjDCmcqn4kuDgwGoDLnM51MUYxNsirrLIg304VWgwuksSn/XCdLh9w
         R9YLTcz9fLbqPY9uUUadC6vxVf3IHNQdE9LXc=
MIME-Version: 1.0
In-Reply-To: <cone.1245322548.289821.31537.1000@arca>
References: <20090604211103.4214303f.peter@piie.net>
	 <cone.1245086149.988051.6046.1000@deskpiie>
	 <20090616060107.GA4752@liondog.tnic> <200906160747.04094.edt@aei.ca>
	 <20090616205747.GA6356@rhlx01.hs-esslingen.de>
	 <20090617001435.e2d86780.peter@piie.net>
	 <20090617122022.GA13141@rhlx01.hs-esslingen.de>
	 <cone.1245309039.632882.31537.1000@arca>
	 <9ea470500906180329w7c8975b0ra60fa219221d53f6@mail.gmail.com>
	 <cone.1245322548.289821.31537.1000@arca>
Date: Thu, 18 Jun 2009 13:42:59 +0200
Message-ID: <9ea470500906180442r7beb49a8odcb3bf602df78b47@mail.gmail.com>
Subject: Re: [PATCH] Request driver inclusion - acer aspire one fan control
From: Borislav Petkov <petkovbb@googlemail.com>
To: Peter Feuerer <peter@piie.net>
Cc: Andreas Mohr <andi@lisas.de>, Ed Tomlinson <edt@aei.ca>,
       akpm@linux-foundation.org, Len Brown <len.brown@intel.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jun 18, 2009 at 12:55 PM, Peter Feuerer<peter@piie.net> wrote:
>>>> Didn't someone argue that pre_suspend_kernelmode was unnecessary?
>>>> It's still in there. (could be submitted together with the
>>>> Kconfig ACPI depends ;)
>>>
>>> Actually I think pre_suspend_kernelmode is needed, so it won't be
>>> dropped.
>>
>> and it is needed, because...?
>
> It's needed because we do now a clean revert to bios mode before we suspend.
> And after resume we have to switch to kernelmode again, if the driver was in
> kernelmode before suspend. So we need to keep track of in what state the
> driver was before suspending. That's what's this variable is for.

You've got that state in the 'kernelmode' variable. See full comment:
http://marc.info/?l=linux-kernel&m=124482114200865

>>> I'll add the ACPI dependency to Kconfig and submit the patch to lkml
>>> and directly to Linus, as Len doesn't seem to react?! - Boris what do
>>> you think? I mean, even if there's a problem with suspend / resume,
>>> this can also be fixed after the merge window, while all those release
>>> candidates are done.
>>
>> Nope, this has to be fixed before submission. The merge window is open,
>> I think, until mid next week so there's plenty of time.
>
> I'll be only there until Sunday evening. I'm going to be on business trip
> starting on Monday (and returning probably at Saturday). But I'll do my best
> to figure out the problem.
>
> I wasn't able to reproduce the suspend / resume problem Andreas has with
> acerhdf 0.5.9 yesterday and the day before. Do you also have the problem,
> that acerhdf is reading sometimes an unexpected Fan state after resuming?

Will look into it on the weekend.

-- 
Regards/Gruss,
Boris
