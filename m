Return-Path: <linux-kernel-owner+w=401wt.eu-S1752638AbYLCM0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbYLCM0n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 07:26:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbYLCM0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 07:26:33 -0500
Received: from mercuryimc.plus.com ([80.229.200.144]:38813 "EHLO
	mimc.mimc.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752614AbYLCM0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 07:26:32 -0500
Message-ID: <49367AFD.8030600@mimc.co.uk>
Date: Wed, 03 Dec 2008 12:26:37 +0000
From: Mark Jackson <mpfj@mimc.co.uk>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: Badness at mm/backing-dev.c:179
References: <49367691.5060007@mimc.co.uk> <ac3eb2510812030422n15f1be2cn77aa5f66f1046933@mail.gmail.com>
In-Reply-To: <ac3eb2510812030422n15f1be2cn77aa5f66f1046933@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> On Wed, Dec 3, 2008 at 13:07, Mark Jackson <mpfj@mimc.co.uk> wrote:
>> The following commit causes a "Badness at mm/backing-dev.c:179":-
>>
>> f1d0b063d993527754f062c589b73f125024d216 is first bad commit
>> commit f1d0b063d993527754f062c589b73f125024d216
>> Author: Kay Sievers <kay.sievers@vrfy.org>
>> Date:   Tue Dec 2 10:31:50 2008 -0800
>>
>>    bdi: register sysfs bdi device only once per queue
> 
>> Below is the extract from dmesg:-
>>
>> ------------[ cut here ]------------
>> Badness at mm/backing-dev.c:179
> 
> That's a known issue, and will not cause any harm besides printing
> this warning. Andrew added the warning to catch drivers who use one
> single request queue for multiple devices. Currently known are mtd and
> floppy (triggers only if you have more than one device per driver).
> The drivers need to be changed to use a separate queue per device, to
> get rid of this warning.

Okay ... thanks for the info.

Mark

