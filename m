Return-Path: <linux-kernel-owner+w=401wt.eu-S1757997AbZDIDHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997AbZDIDHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 23:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754028AbZDIDGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 23:06:54 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:60046 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021AbZDIDGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 23:06:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AKnvscYUi48vk5IVSl/D48/cBhOOSsZpdg7KZh87TGoJ2gZdvRh+GRHzn1HHrVSnr8
         uS+LH7852KVp/+zem6cTyLTPu0EhAPYCmJYYHKGA6dV8XPxLE68Wcydodf/QBjE6oqPN
         ZGFrjec6XOqZ9hh1RvYjfpeBEKpSHKF1EFFb0=
MIME-Version: 1.0
In-Reply-To: <3e8340490904082000h39a19ad8mc2c2fe9a9ab88685@mail.gmail.com>
References: <dd18b0c30904081919h7cc8333aw8e2693969a0998bf@mail.gmail.com>
	 <3e8340490904081938r12f20741kec6c4c7068bd4c45@mail.gmail.com>
	 <dd18b0c30904081950t4ce7186fy4430ceeb36540232@mail.gmail.com>
	 <3e8340490904082000h39a19ad8mc2c2fe9a9ab88685@mail.gmail.com>
Date: Wed, 8 Apr 2009 20:06:51 -0700
Message-ID: <dd18b0c30904082006i5be7c183hbade2f29504c3f5a@mail.gmail.com>
Subject: Re: BUG kmalloc-2048: Invalid object pointer 0xf656ad80
From: Justin Mattock <justinmattock@gmail.com>
To: Bryan Donlan <bdonlan@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 8, 2009 at 8:00 PM, Bryan Donlan <bdonlan@gmail.com> wrote:
> On Wed, Apr 8, 2009 at 10:50 PM, Justin Mattock <justinmattock@gmail.com> wrote:
>> On Wed, Apr 8, 2009 at 7:38 PM, Bryan Donlan <bdonlan@gmail.com> wrote:
>>> On Wed, Apr 8, 2009 at 10:19 PM, Justin Mattock <justinmattock@gmail.com> wrote:
>>>> doing a:
>>>> sudo /sbin/rmmod wl
>>>> (generated a bug message)
>>> [snip]
>>>> The kernel is tainted with nvidia, and a broadcom wl.
>>>
>>> Would this broadcom wl be the very module you're trying to remove?
>>> What makes you think this isn't a bug in this wl binary module? From
>>> the looks of the backtrace it's dying due to a free of a wild pointer
>>> right in the middle of the wl module - it certainly doesn't look like
>>> it came from some other subsystem...
>>>
>>
>> yup,
>> remove wl, in exchange
>> for ndiswrapper. and poof
>> this showed up..
>
> The bug came up in the wl module's removal code - I'd suggest just not
> loading it in the first place.
>

The module sounded like a good idea,
the problem I have(not sure if this is kernel related)
is after the network is up, loading anything takes
a good 30's, then after about 15min later my router will
do a reset(disconnecting any machine connected). could be something missing
with wpasupplicant, kernel, some lib, who knows...
(at this point my main goal is to get the rest of
the system built before dealing with quirks).

regards,

-- 
Justin P. Mattock
