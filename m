Return-Path: <linux-kernel-owner+w=401wt.eu-S1762596AbYA1Vdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762596AbYA1Vdd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 16:33:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbYA1VdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 16:33:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49478 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbYA1VdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 16:33:25 -0500
Message-ID: <479E4918.3010204@zytor.com>
Date: Mon, 28 Jan 2008 13:28:56 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@elte.hu>, Ian Campbell <ijc@hellion.org.uk>,
       =?ISO-8859-1?Q?Mika_Penttil=E4?= <mika.penttila@kolumbus.fi>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native
 format.
References: <1201167544.30671.64.camel@cthulhu.hellion.org.uk> <200801282126.45751.rjw@sisk.pl> <479E3EC6.5070800@goop.org> <200801282150.15411.rjw@sisk.pl>
In-Reply-To: <200801282150.15411.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Monday, 28 of January 2008, Jeremy Fitzhardinge wrote:
>> Rafael J. Wysocki wrote:
>>> Actually, no.  We only do that with the kernel code mapping which should be
>>> safe as long as TLBs are not flushed (and they aren't).
>>>   
>> Er, what?  Assuming the TLB will retain some mappings while you 
>> overwrite the pagetable is a highly dubious prospect.  Are you copying 
>> the same values over, or something else?
> 
> As long as a relocatable kernel is not used to restore a non-relocatable one
> (or vice versa), we're copying the same values over.
> 

So that case is deliberately considered broken?

	-hpa
