Return-Path: <linux-kernel-owner+w=401wt.eu-S1757909AbZFIBtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909AbZFIBtg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 21:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757621AbZFIBsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 21:48:52 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:64516 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757750AbZFIBsv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 21:48:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vWtej+7P0BiGbxmKSGllEsQbPH6aO3PqbNtNn3ytnrSqm9UfuEyz5V8GGWTe6zsxfn
         PyfvOIyQlbAMxQmRGvpGrYUelSffith0siC299fK6BmuK+FlCsWzbX2+5WopYqbot5AG
         frIUrwOoHfFFzBG7Vnm08cV/p2YhqyROLb8RQ=
MIME-Version: 1.0
In-Reply-To: <20090608161929.GD32140@n2100.arm.linux.org.uk>
References: <20090605131625.GC1376@ucw.cz>
	 <20090607152152.GA7785@n2100.arm.linux.org.uk>
	 <f17812d70906072358i69b4ce09oeb6cd455277b050f@mail.gmail.com>
	 <20090608161929.GD32140@n2100.arm.linux.org.uk>
Date: Tue, 9 Jun 2009 09:43:31 +0800
Message-ID: <f17812d70906081843x6731898fl35252664e5a580a1@mail.gmail.com>
Subject: Re: zaurus needs generic pxa suspend/resume routines
From: Eric Miao <eric.y.miao@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Pavel Machek <pavel@ucw.cz>, rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       dbaryshkov@gmail.com, omegamoon@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 9, 2009 at 12:19 AM, Russell King - ARM
Linux<linux@arm.linux.org.uk> wrote:
> On Mon, Jun 08, 2009 at 02:58:54PM +0800, Eric Miao wrote:
>> On Sun, Jun 7, 2009 at 11:21 PM, Russell King - ARM
>> Linux<linux@arm.linux.org.uk> wrote:
>> > On Fri, Jun 05, 2009 at 03:16:25PM +0200, Pavel Machek wrote:
>> >> For suspend/resume to work, spitz needs pxa_pm_suspend/resume to be
>> >> called. Otherwise PSPR is not set properly, and system will die during
>> >> resume.
>> >
>> > 100 points for copying lots of people.  0 points for omitting the right
>> > person.  Add Eric.
>> >
>> > Eric, ack?
>> >
>>
>> Yes, I think this is the best trade-off for the moment.
>>
>> Acked-by: Eric Miao <eric.miao@marvell.com>
>>
>> And Russell you may want to queue this for this -rc phase, looks
>> it's still -rc8-git5.
>
> I think it's missed .30, unless Linus does a -rc9.  I sent what was
> probably my final pull request last night.
>

That should be fine. There are some other changes in my
'sharpsl_pm' branch, so I'd queue this patch for the next
merge window and make some adjustment.

-- 
Cheers
- eric
