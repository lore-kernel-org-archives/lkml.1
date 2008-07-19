Return-Path: <linux-kernel-owner+w=401wt.eu-S1755952AbYGSRQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbYGSRQE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 13:16:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754118AbYGSRPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 13:15:54 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:1106 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165AbYGSRPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 13:15:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dj41M3UfUWVZcTOGSAKRJE+pzjbO22/nIXblm0R4JcVM9pCCeobImSShcetzz40IqJ
         8O4Xx/ZQmx1sz5cTP9zp2z8Hrjyh+4WO9mJeJ4Rpfph0QDCnzeP1jT9Lv46h1/EGLwis
         O9Ax7ihBiXqT92aqyGbVI/W2jY9/eqFkRgg2w=
Message-ID: <dd18b0c30807191015i378c0f4euec76757ee285ed70@mail.gmail.com>
Date: Sat, 19 Jul 2008 10:15:52 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Jack Howarth" <howarth@bromo.msbb.uc.edu>
Subject: Re: macbook2,2 latest git mmconfig issues
Cc: "Yinghai Lu" <yhlu.kernel@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080719162856.GA14334@bromo.msbb.uc.edu>
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
	 <dd18b0c30807190854w17059d63g10e1e199f855988b@mail.gmail.com>
	 <20080719162856.GA14334@bromo.msbb.uc.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2008 at 9:28 AM, Jack Howarth <howarth@bromo.msbb.uc.edu> wrote:
> On Sat, Jul 19, 2008 at 08:54:58AM -0700, Justin Mattock wrote:
>>
>> >From over here; do you think grub
>> has something to do with this error?
>> why: when installing the intaller was broken
>> thus having to download the latest grub and manually
>> plug in the partitions and so forth.
>>  when using the latest git(a day ago) I was using
>> an older version it seems of grub. But this wouldn't explain
>> why I received the PCI: not using MMCONFIG error
>> I need right now to make sure the name is correct
>> "MacBook2" and "Apple", and make sure 0x3f
>> is right also. You never know maybe these get changed with
>> each version of the mac's. Overall this is a pretty nasty bug
>> leaving completely out of business.
>> --
>> Justin P. Mattock
>
> Justin,
>   The current tip from earlier this morning is booting fine under
> Fedora 9 here on my MacBook Pro v2 (build with CONFIG_PCIEASPM unset).
> I am rebuilding tip with CONFIG_PCIEASPM=y in case the issue is fixed
> or has gone latent on tip. If not, I'll update my bugzilla and try
> to get Jesse to take a look at it.
>                     Jack
>
>

when using the boot options
debug initctl_debug vga=790
I'm able to see the hardisk is being mounted alsa
is activated netfiler is being activated, but then
just stops giving me the:
VFS cannot mount on root filesystem error
keep in mind this is when using "any" option
in PCI, when using MMCONFIG
im getting what you where getting
I'm just confused on how the system was working
without any errors with "Direct" in pci
and now none of the options are working.
The posotive side is better work this issue now,
rather than later. what I'll try is loading a fresh install
of nubuntu, and then compile the kernel with there .config
to see if I'm able to start. Also they added apparmor so I'm not sure if
this is causing problems as well.
-- 
Justin P. Mattock
