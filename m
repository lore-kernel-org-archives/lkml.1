Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbYGWUZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbYGWUZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 16:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755086AbYGWUZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 16:25:20 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:57254 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052AbYGWUZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 16:25:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=gQ+iIAvHGNqRq9d59fDvPGcqRrifftD7k/HjYGc1UJBjqtBsV2H9XwXfNgbvAwYLAy
         Uv96FvlKCP08EAfqpHj0pigb/r8l9wZQDOrMCnoNf8oTuPdfoU6vajrBITgE4TUFZDbK
         lM9ICFJR2U45zwBz7RK9l5CejNcFlxs5dJyls=
Message-ID: <5a4c581d0807231325v5150ed6qbea2798608a98bd7@mail.gmail.com>
Date: Wed, 23 Jul 2008 22:25:18 +0200
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: "James Bottomley" <James.Bottomley@hansenpartnership.com>
Subject: Re: [Cbe-oss-dev] [regression/bisected] corrupt CD data after media change and delay
Cc: "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>,
       linux-scsi@vger.kernel.org,
       "Linux Kernel Development" <linux-kernel@vger.kernel.org>,
       "Maarten Bressers" <mbres@gentoo.org>, "Daniel Drake" <dsd@gentoo.org>,
       "Cell Broadband Engine OSS Development" <cbe-oss-dev@ozlabs.org>
In-Reply-To: <1215956031.4326.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0806061458300.6228@vixen.sonytel.be>
	 <5a4c581d0806180147qf8fc731y527c79bfb73401b2@mail.gmail.com>
	 <Pine.LNX.4.64.0806181156460.13297@vixen.sonytel.be>
	 <5a4c581d0806180515g5f24e9d9m85369bfa0a5f2228@mail.gmail.com>
	 <5a4c581d0806210718m77be63c9l444d8d7d7a5266bd@mail.gmail.com>
	 <Pine.LNX.4.64.0806221018220.9736@vixen.sonytel.be>
	 <5a4c581d0806220614seab6598ufa798d8642295495@mail.gmail.com>
	 <5a4c581d0807111425r72e39528w841e24a9b956c245@mail.gmail.com>
	 <5a4c581d0807120508m758df950i76fabdb70dfa2d07@mail.gmail.com>
	 <1215956031.4326.4.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 13, 2008 at 3:33 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Sat, 2008-07-12 at 14:08 +0200, Alessandro Suardi wrote:
>> On Fri, Jul 11, 2008 at 11:25 PM, Alessandro Suardi
>> sr0: rw=0, want=3291928, limit=2097151
>> [asuardi@sandman sdlmame0126]$ h | grep siz
>>   958  cat /sys/block/sr0/size
>>  1031  h | grep siz
>> [asuardi@sandman sdlmame0126]$ !958
>> cat /sys/block/sr0/size
>> 6993536
>>
>> <eject, remount DVD>
>>
>> [asuardi@sandman sdlmame0126]$ !mount
>> mount -r /cdrom
>> [asuardi@sandman sdlmame0126]$ cat /sys/block/sr0/size
>> 6993536
>>
>> <now everything works fine>
>>
>> Possibly a new bug then - since size is always the same ?
>
> It looks like a re-manifestation of Geert's bug.
>
> You said everything worked in -rc7, and there actually have been no sr
> changes at all between then and now, so I'm a bit confused as to how it
> could reappear.  Could you try a bisection search for it (first
> re-verify -rc7 is OK, just in case that's a false negative).

I have been away a few days - I'll try this weekend rebuilding
 older kernels (I save religiously my .configs for every kernel
 I built in the last, um, five years at least) and give the reboot/
 DVD mount/access sequence a go...

The good news is that in 2.6.26-git4, -git9, -git10 I have been
 unable to reproduce the issue a single time. Still, I'm willing
 to make a bit more effort in trying to reproduce.

--alessandro

 "Give me love / Or give me hate
 Give me anything that's not just ok"

 (Sophia, 'Weightless')
