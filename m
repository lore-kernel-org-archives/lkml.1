Return-Path: <linux-kernel-owner+w=401wt.eu-S1753259AbYGSG6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbYGSG6d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 02:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbYGSG60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 02:58:26 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:58876 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbYGSG6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 02:58:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WaPsgIOJdG7zCsbtJBwro4tQHEu4g8nX2H16ia1k5a9Vz60PGO4QTerhBn7iEJHddl
         vCbz9hGxYKwQs7sGcDH8gRHsRra8MZusyLp+kCkzJn+T1B4laIdcFKgM6CMrdjjyDPGF
         1X+K9LecSLuY4Jaecm+Hn7oiAHLSyU8CYkbuc=
Message-ID: <86802c440807182358v6db3ba5eideed118fd643c84f@mail.gmail.com>
Date: Fri, 18 Jul 2008 23:58:24 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Justin Mattock" <justinmattock@gmail.com>
Subject: Re: macbook2,2 latest git mmconfig issues
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jack Howarth" <howarth@bromo.msbb.uc.edu>
In-Reply-To: <dd18b0c30807182354h429ea664gb90b7de55608d0bd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30807182039u3e590e50p5d76624dd9e5b1d8@mail.gmail.com>
	 <86802c440807182145qa3d17e9k210c498109d86b58@mail.gmail.com>
	 <dd18b0c30807182254i49de078bhe5e48ab13e7b01ac@mail.gmail.com>
	 <dd18b0c30807182354h429ea664gb90b7de55608d0bd@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 11:54 PM, Justin Mattock
<justinmattock@gmail.com> wrote:
> On Fri, Jul 18, 2008 at 10:54 PM, Justin Mattock
> <justinmattock@gmail.com> wrote:
>> On Fri, Jul 18, 2008 at 9:45 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>>> On Fri, Jul 18, 2008 at 8:39 PM, Justin Mattock <justinmattock@gmail.com> wrote:
>>>> Hello;
>>>> Well I couldn't really see what was happening
>>>> until I could experience this myself;
>>>> It seems the macbook pro ati chipset
>>>> is having the same problem as jack was with mmconfig yesterday.
>>>> I'm confused as to why my system was able to run this kernel(2.6.26.git1)
>>>> without a problem, now after doing a reinstall of the operating system
>>>> I am confronted with this same issue. How do I find the 0x3f number on
>>>> my system,
>>>> so I could plug that into the patch? to see if I can boot up
>>>> Now keep in mind the only difference with this install is the
>>>> installer took a dump
>>>> therefore you have to manually install grub(could this be the source
>>>> of the issue?)
>>>> regards;
>>>
>>> can you disable ASPM in your config.?
>>>
>>> YH
>>>
>>
>> I enabled and disabled in the pci section
>> PCIEASPM still the same results.
>> applied the patch as well i.g.
>> mmconf_dmi_table
>> going to try detect end_bus_number patch to
>> see if it works
>> --
>> Justin P. Mattock
>>
>
> applied both patches and messed with boot options
> but no go:
> this is what I'm seeing
> PCI: Fatal no config space access function found
> ata-piix 0000:00:1f11 device not available
> because of BAR0 [0xf0-0x1f7] collisions

can you send out your .config?

YH
