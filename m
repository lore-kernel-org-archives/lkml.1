Return-Path: <linux-kernel-owner+w=401wt.eu-S1760286AbYGAQS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760286AbYGAQS6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 12:18:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756414AbYGAQSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 12:18:50 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:6848 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755976AbYGAQSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 12:18:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TB2xjZL03OXvWzapu7OAya1LwQSqHuOp/1Du/bCA9Huh8kHVhdYkK4vgn/+FnD9knr
         6RYAoTtiZOHaAoIAhMaELzAKtCUL/ztKfeqB8MXuiDTOvQiPxdvr6ojRfU8iuMSFjKkk
         BroL8VBhKfZh8LBzoU9XaLb52YDeB1JAcSAjo=
Message-ID: <dd18b0c30807010918p48cfbe2bnb7e4a2bf00a01638@mail.gmail.com>
Date: Tue, 1 Jul 2008 16:18:45 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: dsdt buggy acpi
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "ACPI Devel Maling List" <linux-acpi@vger.kernel.org>
In-Reply-To: <200807011619.53339.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30806302339q7b3effybf8a7f619b009262@mail.gmail.com>
	 <200807011619.53339.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 1, 2008 at 2:19 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday, 1 of July 2008, Justin Mattock wrote:
>> With not knowing what I'm doing, I think I need assistance. With looking at acpi
>> I decided to have a try at the dsdt.dat bit(pretty easy so far) except
>> I'm being confronted with some errors, in of which
>> I don't know how to resolve(still Googling for the answer) If anybody
>> has any answers it would sure be appreciated.
>> errors below:
>>
>> Intel ACPI Component Architecture
>> ASL Optimizing Compiler version 20051216 [Jan  9 2006]
>> Copyright (C) 2000 - 2005 Intel Corporation
>> Supports ACPI Specification Revision 3.0
>>
>> No back ptr to Op: type 8
>> No back ptr to Op: type 8
>> dsdt.dsl   511:             If (And (PDC0, 0x08))
>> Error    1061 -   Object does not exist ^  (PDC0)
>>
>> dsdt.dsl   514:                 If (And (PDC0, 0x10))
>> Error    1061 -       Object does not exist ^  (PDC0)
>>
>> dsdt.dsl   521:             If (And (PDC1, 0x08))
>> Error    1065 -                         ^ Object not accessible from
>> this scope (PDC1)
>>
>> dsdt.dsl   524:                 If (And (PDC1, 0x10))
>> Error    1065 -                             ^ Object not accessible
>> from this scope (PDC1)
>>
>> ASL Input:  dsdt.dsl - 5040 lines, 171343 bytes, 1814 keywords
>> Compilation complete. 4 Errors, 0 Warnings, 0 Remarks, 609 Optimizations
>>
>> I'm figuring if I can at least fix this, then maybe this will help
>> with: http://bugzilla.kernel.org/show_bug.cgi?id=10724
>> acpi gpe storm regression.(or at least get me this much closer to
>> figuring out what is up with that).
>
> Please have a look at http://www.lesswatts.org/projects/acpi/
>
> Thanks,
> Rafael
>

Cool; thanks.
I'll check that out and see where and how I can locate the dsdt
manufacture number,  then see if I can fix the broken dsdt error and
apply this to the kernel and see what happens.
regards;

-- 
Justin P. Mattock
