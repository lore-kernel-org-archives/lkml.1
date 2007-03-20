Return-Path: <linux-kernel-owner+w=401wt.eu-S1751253AbXCTOzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751253AbXCTOzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 10:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbXCTOzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 10:55:50 -0400
Received: from tapsys.com ([72.36.178.242]:35742 "EHLO tapsys.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbXCTOzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 10:55:49 -0400
Message-ID: <45FFF5E5.5040201@madrabbit.org>
Date: Tue, 20 Mar 2007 07:55:33 -0700
From: Ray Lee <ray-lk@madrabbit.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
Cc: Adrian Bunk <bunk@stusta.de>, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>
Subject: Re: Odd suspend regression in 2.6.21-rc[123]
References: <45F0C018.2020409@madrabbit.org> <20070320095638.GA19137@elf.ucw.cz>
In-Reply-To: <20070320095638.GA19137@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>> In 2.6.21-rc1,2,3, my laptop will fully suspend to ram, but then
>> *immediately* resumes back from suspension. (It resumes just fine, as well.)
>>
>> Nothing out of the ordinary is logged, and this happens even when
>> booting into init=/bin/sh with minimal modules loaded and executing
>> s2ram from that minimal environment.
>>
>> I'm going to ponder the 2.6.20 to 2.6.21-rc1 changelog, but I'm hoping
>> someone with a clue can offer a suggestion before I end up bisecting the
>> whole thing. (Wouldn't be so bad, except I'm given to understand that
>> there are multiple places in those changes where nothing quite works
>> with respect to suspend.)
>>
>> HP/Compaq NX6125 system, AMD64, dmesg attached.
> 
> Known problem in ACPI, hopefully already fixed?

Mostly. The ACPI git tree has the fix
(1d99967badac599c0d1db0b45c99e073e8e98cd4), but Len has yet to push it
to Linus. Hopefully that'll happen before 2.6.21 final.

Thanks Pavel,

Ray

