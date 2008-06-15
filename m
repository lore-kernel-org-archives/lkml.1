Return-Path: <linux-kernel-owner+w=401wt.eu-S1753851AbYFOTUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbYFOTUi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 15:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbYFOTU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 15:20:29 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:44818 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbYFOTU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 15:20:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=i7X6Bp3OnTitc56Fbi1iM10tTl7kq2slPD62ZtHHJ6JO8ezPh1rFiZ51BU+J1PL1Tw
         1ebeKFlArAikR57SZC5LcoYUl+oZOGymFqpCtyqptxuT3yVDBdvCNO/0SrsR0+DpJGZ5
         WiksiuuFHPpWn9K5iZ076uVTrjzhu167nG8LE=
Message-ID: <86802c440806151220l358ca541s9d87fe2acc360e8@mail.gmail.com>
Date: Sun, 15 Jun 2008 12:20:27 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: webmaster@dragonslave.de
Subject: Re: linux-next Regression: Unable to locate IOAPIC
Cc: "Alexey Starikovskiy" <aystarik@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-acpi@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <200806152114.33007.dex@dragonslave.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806051100.12885.dex@dragonslave.de>
	 <48536E3B.4000703@gmail.com>
	 <86802c440806140126l7a949783of0fb08d11ae07bef@mail.gmail.com>
	 <200806152114.33007.dex@dragonslave.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2008 at 12:14 PM, Daniel Exner <dex@dragonslave.de> wrote:
> Hi all,
>
> Yinghai Lu wrote:
>> >> To clarify myself:
>> >> 2.6.25.5:  --> relatively fast no IOAPIC Errors in dmesg
>> >> 2.6.26-rc5:   --> relatively  no IOAPIC Errors in dmesg
>> >> 2.6.26-rc5 + git-acpi Patch:   --> relatively  no IOAPIC Errors in dmesg
>> >> 2.6.26-rc5 +  linux-next snapshot 20080604 --> even slower than before
>> >> my ide Patch many "unable to locate IOAPIC" Errors
>> >>
>> >>
>> >> So I think the problem lies not in the acpi tree but somewhre else.
>> >>
>> >> Is it possible to tell git to explicitly _exclude_ a specific tree while
>> >> bisecting?
>>
>> can you check if the attached patch fix the problem?
>> it will not check entries before MP_intsrc_info...
> This fixed it, thanks :)
>
> Also maschine feels not as fast as with 2.6.25.x but noticeable faster :)
>
> I guss you no longer need the complete dmesg output?

still need that... wonder why your irq routing have same entris from
your BIOS/ACPI?

YH
