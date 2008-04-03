Return-Path: <linux-kernel-owner+w=401wt.eu-S1762289AbYDCT7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762289AbYDCT7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760657AbYDCT7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:59:43 -0400
Received: from mail.hauppauge.com ([167.206.143.4]:2210 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757607AbYDCT7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:59:42 -0400
Message-ID: <47F536FF.8060105@linuxtv.org>
From: mkrufky@linuxtv.org
To: harvey.harrison@gmail.com
Cc: abraham.manu@gmail.com, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mchehab@infradead.org
Subject: Re: [v4l-dvb-maintainer] [PATCH] media: replace	remaining	__FUNCT
	ION__ occurences
Date: Thu, 3 Apr 2008 14:58:55 -0500 
MIME-Version: 1.0
X-Mailer: Internet Mail Service (5.5.2657.72)
in-reply-to: <1204613661.22933.110.camel@brick>
x-originalarrivaltime: 03 Apr 2008 20:57:26.0791 (UTC) FILETIME=[52AC3170:01C895CD]
user-agent: Thunderbird 2.0.0.12 (Windows/20080213)
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> On Tue, 2008-03-04 at 01:38 -0500, Michael Krufky wrote:
>   
>> Manu Abraham wrote:
>>     
>>> Michael Krufky wrote:
>>>       
>>>> On Mon, Mar 3, 2008 at 7:03 PM, Harvey Harrison
>>>> <harvey.harrison@gmail.com> wrote:
>>>>         
>>>>> __FUNCTION__ is gcc-specific, use __func__
>>>>>
>>>>>  Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
>>>>>   162 files changed, 892 insertions(+), 892 deletions(-)
>>>>>           
>>>> If we apply this, can it be broken down into several smaller patches?
>>>> I am in the midst of a large overhaul of the tuning subsystem, and if
>>>> this all gets applied at once, it will wreck havoc on my pending
>>>> changesets.
>>>>         
>>> Please make sure your changes don't conflict with the multiproto tree
>>> changes.
>>>
>>> Regards,
>>> Manu
>>>       
>> Manu,
>>
>> Does that mean that you plan to merge multiproto soon?  If that's the
>> case, then we'd be better off if you give Harvey an "exclude list" of
>> files he should stay away from.  He can regenerate patches to those
>> files after multiproto is merged.
>>
>>     
>
> Or just apply it after both of you have merged and ignore any conflicts,
> I can come back to it at a later time (2.6.26-rc1 maybe?).

Harvey,

The greater portion of my refactoring changes have been merged.  As far 
as I am concerned, you should feel free to send in cleanup changesets now.

Manu,

We can't expect Harvey to avoid conflicts with multiproto -- do you have 
any plans to ACTUALLY merge these changes?  You've been saying "any day 
now" for the past two years.

If you plan to merge multiproto for 2.6.26, then, IMHO, now is the 
time.  Otherwise, it's safe for Harvey to do his cleanups.

Harvey,

If you decide to move forward with these cleanups now, please keep the 
previous discussion in mind -- please generate the changesets against 
the v4l-dvb master repository, hosted on linuxtv.org, and please 
separate the changesets by each level of the directory tree hierarchy.

Regards,

Mike Krufky
