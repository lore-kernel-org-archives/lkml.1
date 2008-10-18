Return-Path: <linux-kernel-owner+w=401wt.eu-S1752194AbYJRR3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbYJRR3u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 13:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751020AbYJRR3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 13:29:43 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:28008 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbYJRR3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 13:29:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=CaVk8+5U7RLhfussy5pJ0JB4Y5ZILVEE67skBIPezIFaRHsYbeEV+yCFEy5Af8Alj0
         XVd5qlDguNvEp7A0gIuxGe6P1j46iYX/6++oTIFFQW1TeqitTojZnRthsEb3ClhRYBgT
         oqx+eYNXVL1RioGOHtZiIODIKcH1C6seHKE5M=
Message-ID: <dd18b0c30810181029r75f069a9h964254075dfd866f@mail.gmail.com>
Date: Sat, 18 Oct 2008 10:29:41 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Steven Noonan" <steven@uplinklabs.net>
Subject: Re: appletouch regression
Cc: "Sven Anders" <anders@anduras.de>,
       "kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <f488382f0810180944i4736a88cl136637261a16ffaa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f488382f0810180552w2078244eiaed1fa100ad4c4c6@mail.gmail.com>
	 <48F9E5EF.4080806@anduras.de>
	 <f488382f0810180944i4736a88cl136637261a16ffaa@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2008 at 9:44 AM, Steven Noonan <steven@uplinklabs.net> wrote:
> 2008/10/18 Sven Anders <anders@anduras.de>:
>> Steven Noonan schrieb:
>>> It seems that the appletouch driver is (sporadically) not detecting my
>>> Apple Trackpad anymore on Linus' current tree (2.6.27-05577-g0cfd810).
>>> When it is misbehaving, it doesn't have any /dev/input/event* entry
>>> that corresponds to the input from appletouch, and dmesg -should- show
>>> the following, as 2.6.27.1 does, but does not:
>>>
>>> appletouch: Geyser mode initialized.
>>> input: appletouch as /class/input/input4
>>> usbcore: registered new interface driver appletouch
>>> appletouch: 17" model detected
>>>
>>> On the current tree, occasionally all I get is:
>>>
>>> usbcore: registered new interface driver appletouch
>>>
>>> It's unfortunately a touchy issue, as it only -occasionally- happens.
>>> A bisection will be a pain in the butt, but I'm starting it right now
>>> anyway.
>>
>> Hmm, strange...
>>
>> I didn't change anything in the initialization routines. But I will take a look
>> into the changes, if something is missing or wrong...
>>
>
> I am pretty sure the two patches recently submitted by you are not
> guilty (I tried reverting both of them, which had no effect).
>
> Still working on the git-bisect. Fell asleep in the middle of it last night. O.o
>
> - Steven
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

I too have a lifeless apple touchpad,
not sure when this started,due to never really using
it unless I'm in a remote location.

-- 
Justin P. Mattock
