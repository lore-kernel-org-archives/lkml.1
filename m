Return-Path: <linux-kernel-owner+w=401wt.eu-S1755250AbYGSTfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbYGSTfi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 15:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbYGSTfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 15:35:31 -0400
Received: from ag-out-0708.google.com ([72.14.246.248]:32573 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbYGSTfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 15:35:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IxJf8Kb0y6bSScgbX+dXvUpbwznUhbeQXOYCfvtX4s577ygrRfhH150W4qQl5QSA+3
         rhiCvcY9kVFfnjK2tFiIM0YcpE2mSyL9YiKPI0GSh8ba1xDRVHoicM6Vm/V4VprlSuvF
         /M49bIcGZGvKet6R4is140CrahIlO6Q83uq9M=
Message-ID: <dd18b0c30807191235w43843c57oa6c7ee94c0c96dd@mail.gmail.com>
Date: Sat, 19 Jul 2008 12:35:28 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Jack Howarth" <howarth@bromo.msbb.uc.edu>
Subject: Re: macbook2,2 latest git mmconfig issues
Cc: "Yinghai Lu" <yhlu.kernel@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080719175818.GA19250@bromo.msbb.uc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30807182039u3e590e50p5d76624dd9e5b1d8@mail.gmail.com>
	 <dd18b0c30807182254i49de078bhe5e48ab13e7b01ac@mail.gmail.com>
	 <dd18b0c30807182354h429ea664gb90b7de55608d0bd@mail.gmail.com>
	 <20080719131038.GA13168@bromo.msbb.uc.edu>
	 <dd18b0c30807190753q22259690jcae780de13c8560d@mail.gmail.com>
	 <20080719151453.GA13792@bromo.msbb.uc.edu>
	 <dd18b0c30807190854w17059d63g10e1e199f855988b@mail.gmail.com>
	 <20080719162856.GA14334@bromo.msbb.uc.edu>
	 <dd18b0c30807191015i378c0f4euec76757ee285ed70@mail.gmail.com>
	 <20080719175818.GA19250@bromo.msbb.uc.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2008 at 10:58 AM, Jack Howarth
<howarth@bromo.msbb.uc.edu> wrote:
> On Sat, Jul 19, 2008 at 10:15:52AM -0700, Justin Mattock wrote:
>>
>> when using the boot options
>> debug initctl_debug vga=790
>> I'm able to see the hardisk is being mounted alsa
>> is activated netfiler is being activated, but then
>> just stops giving me the:
>> VFS cannot mount on root filesystem error
>> keep in mind this is when using "any" option
>> in PCI, when using MMCONFIG
>> im getting what you where getting
>> I'm just confused on how the system was working
>> without any errors with "Direct" in pci
>> and now none of the options are working.
>> The posotive side is better work this issue now,
>> rather than later. what I'll try is loading a fresh install
>> of nubuntu, and then compile the kernel with there .config
>> to see if I'm able to start. Also they added apparmor so I'm not sure if
>> this is causing problems as well.
>> --
>> Justin P. Mattock
>
> Justin,
>   Just to be clear, you do have CONFIG_PCIEASPM unset in your .config,
> right? All 2.6.26 kernels I have tried (including tip) hang during the
> boot when built with that option.
>                Jack
>

yep; didn't choose this option.
I'll check again to make sure.
just loaded a fresh 2.6.26 without any patches
just to be sure and still unable to mount  VFS error
where can I find the patches you used that worked
to see if this works over here. Is there some place I should look in userspace
as well to see if I'm missing something?

-- 
Justin P. Mattock
