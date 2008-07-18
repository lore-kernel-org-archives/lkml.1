Return-Path: <linux-kernel-owner+w=401wt.eu-S1759222AbYGRSU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759222AbYGRSU7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 14:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754513AbYGRSUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 14:20:52 -0400
Received: from hu-out-0506.google.com ([72.14.214.233]:48698 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441AbYGRSUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 14:20:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WSoLoBtAHuIkJpKh73xbePCEMzAybGMudLU6BJoyEJiyjJgPmSRPpPloqsvBTssCSC
         VfyDLzIa8Dg5AvbqeX0KyIX1t6vmm7rrV9HGziyTxX6E6Escy81f9TEJvlHE5BTtF1xg
         ZSi5SxcdatLgTlcXYSmDbeERohWO8m9UwFS20=
Message-ID: <dd18b0c30807181120r4462e904t94d37dbd383995ba@mail.gmail.com>
Date: Fri, 18 Jul 2008 18:20:47 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: 2.6.26-rc9-git9 doesn't boot on Macintel
Cc: "Jack Howarth" <howarth@bromo.msbb.uc.edu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <86802c440807180936h6eaad29fo1788e4e2d54b0df0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080717034418.GA18951@bromo.msbb.uc.edu>
	 <86802c440807162348m6d05b912x7b3f655d7f9efb93@mail.gmail.com>
	 <20080718011532.GA30920@bromo.msbb.uc.edu>
	 <86802c440807171825m24ffe140o81bb76286823568e@mail.gmail.com>
	 <20080718060935.GA32345@bromo.msbb.uc.edu>
	 <86802c440807172322s5dabbd1bx297742d782e373d6@mail.gmail.com>
	 <20080718120930.GA2916@bromo.msbb.uc.edu>
	 <86802c440807180919id6220ecqe0a25b2a94dc39c0@mail.gmail.com>
	 <20080718162923.GA6100@bromo.msbb.uc.edu>
	 <86802c440807180936h6eaad29fo1788e4e2d54b0df0@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 4:36 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Fri, Jul 18, 2008 at 9:29 AM, Jack Howarth <howarth@bromo.msbb.uc.edu> wrote:
>> YH,
>>   I'll file a radar bug report on this with Apple but wouldn't
>> hold my breath for them to fix the firmware. Also, it would be
>> a good idea to encourage all of the folks using 2.6.26 on
>> Macintel to watch out for the "MMCONFIG not used" message in
>> their dmesg and report that to you. I strongly suspect that
>> the MacBook Pro v2 isn't the only model with broken firmware.
>>                   Jack
>>
>> On Fri, Jul 18, 2008 at 09:19:19AM -0700, Yinghai Lu wrote:
>>> On Fri, Jul 18, 2008 at 5:09 AM, Jack Howarth <howarth@bromo.msbb.uc.edu> wrote:
>>> > YH,
>>> >   Do you see anything in the pci earlydump and the associated lspci --vvxxxx
>>> > output that sheds any light on why we have to clean up the dmi with your
>>> > mmconfig patch on a MacBookPro2? I am wondering if the BIOS information is
>>> > being misused by the linux kernel or if the BIOS is just buggy.
>
> it only happened when 3G ram installed.
>
> when 2G installed, it will use [0xe0000000 - 0xf0000000), for bus [0,255]
> and that is ok
>
> YH
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Where might us mac users locate a custom
dsdt to try?


-- 
Justin P. Mattock
