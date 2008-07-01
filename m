Return-Path: <linux-kernel-owner+w=401wt.eu-S1755544AbYGAHHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbYGAHHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 03:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753080AbYGAHHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 03:07:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36702 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbYGAHHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 03:07:05 -0400
Message-ID: <4869D67B.4060902@zytor.com>
Date: Tue, 01 Jul 2008 00:02:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, kernel-testers@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFT] x86 acpi: normalize segment descriptor register on resume
References: <200807010148.02135.rjw@sisk.pl> <20080701063133.GC16642@elte.hu>
In-Reply-To: <20080701063133.GC16642@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
>> Hi,
>>
>> The appended patch fixes a regression and is considered as 2.6.26 
>> material. Everyone having a box with working suspend to RAM is gently 
>> requested to test it and verify if it doesn't break things.
>>
>> The patch applies to the current -git.
> 
> it's been under testing in tip/out-of-tree for about a week:
> 
> | commit ee901dc1b9ab94a37ba2efc296fe9ba72bc75adf
> | Author:     H. Peter Anvin <hpa@zytor.com>
> | AuthorDate: Tue Jun 24 23:03:48 2008 +0200
> | Commit:     Ingo Molnar <mingo@elte.hu>
> | CommitDate: Wed Jun 25 18:48:13 2008 +0200
> |
> |     x86 ACPI: normalize segment descriptor register on resume
> 
> no problems caused by it so far.
> 

It still seems incredibly risky to push this for 2.6.26, especially 
given the Elan revelation.  I think it needs to be tested on the 2.6.27 
track, and then possibly be pushed back via the 2.6.26-stable route.

	-hpa
