Return-Path: <linux-kernel-owner+w=401wt.eu-S1755672AbYGSPzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672AbYGSPzM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 11:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbYGSPzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 11:55:00 -0400
Received: from ag-out-0708.google.com ([72.14.246.249]:4658 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbYGSPy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 11:54:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=NFhZ5VAcE23ZIP7+wReWUCt/LUZiW9SLZL+nxDyqkbESKz+WJk1YXB4qhOlwccz1Gu
         F7zpDZ8jDS6XwELsUKWLJc8CNn09w+9PZeqbQfTePSHwD9Afzj9aZ3eB7ZSZ7v160bfv
         TGqu3zreYfkHfr7Nzhm0f4PB5vpGzPpEaMBVE=
Message-ID: <dd18b0c30807190854w17059d63g10e1e199f855988b@mail.gmail.com>
Date: Sat, 19 Jul 2008 08:54:58 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Jack Howarth" <howarth@bromo.msbb.uc.edu>
Subject: Re: macbook2,2 latest git mmconfig issues
Cc: "Yinghai Lu" <yhlu.kernel@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080719151453.GA13792@bromo.msbb.uc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30807182039u3e590e50p5d76624dd9e5b1d8@mail.gmail.com>
	 <86802c440807182145qa3d17e9k210c498109d86b58@mail.gmail.com>
	 <dd18b0c30807182254i49de078bhe5e48ab13e7b01ac@mail.gmail.com>
	 <dd18b0c30807182354h429ea664gb90b7de55608d0bd@mail.gmail.com>
	 <20080719131038.GA13168@bromo.msbb.uc.edu>
	 <dd18b0c30807190753q22259690jcae780de13c8560d@mail.gmail.com>
	 <20080719151453.GA13792@bromo.msbb.uc.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2008 at 8:14 AM, Jack Howarth <howarth@bromo.msbb.uc.edu> wrote:
> On Sat, Jul 19, 2008 at 07:53:34AM -0700, Justin Mattock wrote:
>> >
>>
>> could be; but  loading an iso works i.g.
>> after installing it and starting up.
>> these two messages came from after applying
>> the two patches(keep in mind I was tired so maybe
>> plugged them in wrong) before the two patches
>> the MMCONFIG disable message with f0000000
>> that you where receiving. maybe the manufacture
>> on mine needs to be MacBookPro2,2 and the 0x3f
>> needs to be 0x1f. Where do I find these numbers
>> and names on the system? I've done dmidecode
>> but can't seem to make out any of the info
>>
>> --
>> Justin P. Mattock
>
> Justin,
>   I am attempting to build kernel rpms with tip right now.
> My first effort would boot because somehow the modules weren't
> being found (paths were being used with -tip in them). I've removed
> the localversion file from the top level of tip and hope that fixes
> the packaging issues. This issue didn't occur when I used a git
> from the linus kernel branch.
>                            Jack
>

>From over here; do you think grub
has something to do with this error?
why: when installing the intaller was broken
thus having to download the latest grub and manually
plug in the partitions and so forth.
 when using the latest git(a day ago) I was using
an older version it seems of grub. But this wouldn't explain
why I received the PCI: not using MMCONFIG error
I need right now to make sure the name is correct
"MacBook2" and "Apple", and make sure 0x3f
is right also. You never know maybe these get changed with
each version of the mac's. Overall this is a pretty nasty bug
leaving completely out of business.
-- 
Justin P. Mattock
