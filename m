Return-Path: <linux-kernel-owner+w=401wt.eu-S1756794AbYDWSEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbYDWSEi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 14:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753615AbYDWSE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 14:04:27 -0400
Received: from mail.hauppauge.com ([167.206.143.4]:2646 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbYDWSE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 14:04:26 -0400
Message-ID: <480F7A0E.2080202@linuxtv.org>
From: mkrufky@linuxtv.org
To: mchehab@infradead.org
Cc: hverkuil@xs4all.nl, video4linux-list@redhat.com, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, ivtv-devel@ivtvdriver.org,
       biercenator@gmail.com
Subject: Re: [PATCH] Fix VIDIOCGAP corruption in ivtv
Date: Wed, 23 Apr 2008 14:03:58 -0400
MIME-Version: 1.0
X-Mailer: Internet Mail Service (5.5.2657.72)
in-reply-to: <20080423143454.0d50b209@gaivota>
x-originalarrivaltime: 23 Apr 2008 18:01:05.0481 (UTC) FILETIME=[FFFB6B90:01C8A56B]
user-agent: Thunderbird 2.0.0.12 (Windows/20080213)
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro Carvalho Chehab wrote:
> On Sun, 20 Apr 2008 12:10:00 -0400
> Michael Krufky <mkrufky@linuxtv.org> wrote:
>
>   
>> Hans Verkuil wrote:
>>     
>>> On Sunday 20 April 2008 13:27:36 Alan Cox wrote:
>>>   
>>>       
>>>> Frank Bennett reported that ivtv was causing skype to crash. With
>>>> help from one of their developers he showed it was a kernel problem.
>>>> VIDIOCGCAP copies a name into a fixed length buffer - ivtv uses names
>>>> that are too long and does not truncate them so corrupts a few bytes
>>>> of the app data area.
>>>>
>>>> Possibly the names also want trimming but for now this should fix the
>>>> corruption case.
>>>>     
>>>>         
>>> Ouch, nasty one.
>>>
>>> Mauro, can you apply this patch to the v4l-dvb master?
>>>
>>> Mike, this one should obviously go into a 2.6.25 dot-release, and I 
>>> think also to a 2.6.24 dot-release.
>>>
>>> Frank, thank you for reporting this!
>>>
>>> 	Hans
>>>
>>> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
>>>   
>>>       
>> Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
>>     
>
> In this case, it should be reviewed-by.
>
> I should be sending this soon to Linus.


Mauro,

I think it's wrong that you alter signatures.  You did this:

Reviewed-by: <mkrufky@linuxtv.org <mailto:mkrufky@linuxtv.org>>

But I provided this:

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>

I sign the patch, because I have handled it in my -stable queue.


You put my email address without my name!

A signature is sacred and nobody should fudge it.

Please fix it before you send to -git.

-Mike

