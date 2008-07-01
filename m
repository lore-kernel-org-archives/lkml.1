Return-Path: <linux-kernel-owner+w=401wt.eu-S1756597AbYGAQV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbYGAQV3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 12:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbYGAQVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 12:21:18 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58364 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025AbYGAQVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 12:21:16 -0400
Message-ID: <486A5977.8020905@firstfloor.org>
Date: Tue, 01 Jul 2008 18:21:11 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel-testers@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFT] x86 acpi: normalize segment descriptor register on resume
References: <200807010148.02135.rjw@sisk.pl> <20080701063133.GC16642@elte.hu> <4869D67B.4060902@zytor.com> <486A2AC3.2060107@firstfloor.org> <486A5378.7020601@zytor.com>
In-Reply-To: <486A5378.7020601@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Andi Kleen wrote:
>>> It still seems incredibly risky to push this for 2.6.26, especially
>>> given the Elan revelation.
>>
>> Do Elans even support S3?
> 
> I don't know if they do, but I don't know offhand the extent of machines
> that may have that problem, especially since Intel now document it as
> "failures are readily seen".

What document is that exactly?


> 
>>>  I think it needs to be tested on the 2.6.27
>>> track, and then possibly be pushed back via the 2.6.26-stable route.
>>
>> I'm just not sure how many suspend/resume cycles people really do
>> on a early (pre -rc) mainline kernel (or in linux-next for that
>> matter). You usually have to install on a laptop and actually
>> use it.
>>
>> Since this code is only executed on resume some directed testing
>> would be better. That is what Rafael asked for in this mail.
> 
> The issue is mostly if it breaks some obscure system.  I have put it on
> my laptop, Ingo has it on this test system with a suspend-testing cycle,
> and so on, but the number of systems exposed is going to be small.

Right now it looks like a significant number of Dell laptops
are affected by this regression. That's a serious issue.

-Andi
