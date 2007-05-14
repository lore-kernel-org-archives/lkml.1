Return-Path: <linux-kernel-owner+w=401wt.eu-S1758196AbXENTGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196AbXENTGV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 15:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754600AbXENTGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 15:06:15 -0400
Received: from gw.goop.org ([64.81.55.164]:42648 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754355AbXENTGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 15:06:14 -0400
Message-ID: <4648B324.2030801@goop.org>
Date: Mon, 14 May 2007 12:06:12 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RFC] Remove final vestiges of interrupt-related "SA_"
 flags.
References: <Pine.LNX.4.64.0705141433490.14658@localhost.localdomain> <1179169434.7074.9.camel@chaos>
In-Reply-To: <1179169434.7074.9.camel@chaos>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Mon, 2007-05-14 at 14:38 -0400, Robert P. J. Day wrote:
>   
>> diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
>> index 498ff31..c5d7775 100644
>> --- a/Documentation/feature-removal-schedule.txt
>> +++ b/Documentation/feature-removal-schedule.txt
>> @@ -160,15 +160,6 @@ Who:	Greg Kroah-Hartman <gregkh@suse.de>
>>
>>  ---------------------------
>>
>> -What:	Interrupt only SA_* flags
>> -When:	September 2007
>> -Why:	The interrupt related SA_* flags are replaced by IRQF_* to move them
>> -	out of the signal namespace.
>> -
>> -Who:	Thomas Gleixner <tglx@linutronix.de>
>> -
>>     
>
> NAK, the removal date is September 2007 so out of tree folks have some
> time to fix their crap.

This might be a good example of targeting a specific kernel version
rather than a date, since anyone who can't fix this immediately with a
simple search'n'replace is probably trying to support multiple kernels,
and knowing that "2.6.24" (or whatever) is the cut-off version is more
useful than "whatever kernel is current in Sept 2007".

    J
