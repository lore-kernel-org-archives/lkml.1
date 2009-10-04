Return-Path: <linux-kernel-owner+w=401wt.eu-S1758113AbZJDVhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113AbZJDVhh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 17:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758044AbZJDVhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 17:37:36 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:53102 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758036AbZJDVhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 17:37:36 -0400
Message-ID: <4AC91578.2020807@suse.de>
Date: Mon, 05 Oct 2009 01:36:56 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] battery: Fix charge_now returned by broken batteries
References: <1254669853.26496.0.camel@carter> <ca2dc2820910041046i47a1c3dhba82266bb14a440c@mail.gmail.com> <4AC8F02B.6080209@suse.de> <200910042246.23712.rjw@sisk.pl>
In-Reply-To: <200910042246.23712.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

This is not my rule, it was/is the rule of power device class. If you do not agree to it, please change
appropriate documentation.

Regards,
Alex.

Rafael J. Wysocki пишет:
> On Sunday 04 October 2009, Alexey Starikovskiy wrote:
>> Hi Miguel,
> 
> Hi Alex,
> 
>> I am going to reject your patch on the basis, that the battery driver should report only
>> information it gained from battery hardware, not interpret it in any way.
>> As your patch fall into "interpret" category, it does not belong in the kernel and battery
>> driver in particular. You may suggest it to any/all user space battery monitoring applications,
>> this is the place for "interpretations".
> 
> Well, we do quirks for PCI devices, suspend quirks etc. in the kernel, so I'm
> not really sure we should use the "no interpretation" as a general rule.  IMO,
> if there's a known broken system needing a quirk, it may just be more
> reasonable to put the quirk into the kernel than to put it into every single
> user application out there.
> 
> In this particular case we have an evidently quirky hardware (or BIOS) and it's
> not a fundamentally wrong idea to try to address that problem in the kernel.
> 
> Thanks,
> Rafael

