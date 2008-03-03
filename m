Return-Path: <linux-kernel-owner+w=401wt.eu-S1757920AbYCCRLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920AbYCCRLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbYCCRL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:11:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57589 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbYCCRL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:11:28 -0500
Message-ID: <47CC310B.8000305@zytor.com>
Date: Mon, 03 Mar 2008 09:10:35 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: "Klaus S. Madsen" <ksm@hjernemadsen.org>,
       Suspend-devel list <suspend-devel@lists.sourceforge.net>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Regression in 2.6.25-rc3: s2ram segfaults before suspending
References: <20080228150444.GG17932@hjernemadsen.org> <47C6F4F9.90700@zytor.com> <20080228192404.GH17932@hjernemadsen.org> <47C70C01.4020605@zytor.com> <20080228194920.GJ17932@hjernemadsen.org> <47C739A6.5020608@zytor.com> <20080229070028.GK17932@hjernemadsen.org> <47C873AA.6040305@zytor.com> <20080229212654.GL27212@elte.hu> <20080301094525.GQ17932@hjernemadsen.org> <20080303121735.GE28369@elf.ucw.cz>
In-Reply-To: <20080303121735.GE28369@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
>>
>> The only thing I don't understand is why this is suddenly a problem with
>> 2.6.25, and not with 2.6.24? Is there a bug in 2.6.24 and previously
>> that allows real-mode execution of non-executable pages?
> 
> It is strange indeed... Should it be traced as an regression?
> 									Pavel

I'd like to understand what the heck happened, but as far as we can 
observe right now, it's a *progression*, not a regression, since 
executing out of a non-PROT_EXEC area isn't *supposed* to work...

	-hpa
