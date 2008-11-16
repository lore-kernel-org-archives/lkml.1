Return-Path: <linux-kernel-owner+w=401wt.eu-S1754055AbYKPPbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbYKPPbz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 10:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbYKPPbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 10:31:45 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:27635 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbYKPPbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 10:31:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:x-mailer:mime-version:subject:date:cc;
        b=AKkb0PL0ZUXgoSAnhhYwsM5d3W+xA1WB17b5fn8Z9FXcqS72uMFI1m4eQCPUXzRxut
         1MoKkGUUfJE22hzDmrKUqsftMRFYfOxAo3b8DxPQ4u2Eu5Oi4y+0Lj8RenL7bSES23Eu
         +um+AgC95FO543mvkCAGhRYdx77GPmU8wb9b8=
References: <1226722577.3104.4.camel@LiNuX> <1226817681.3133.7.camel@LiNuX> <491FECAE.6050005@gmail.com> <200811161344.07872.rjw@sisk.pl>
Message-Id: <B407D583-A440-402B-AB35-D69BA464F5AD@gmail.com>
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <200811161344.07872.rjw@sisk.pl>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (5F136)
Mime-Version: 1.0 (iPhone Mail 5F136)
Subject: Re: ACPI: EC: GPE storm detected, transactions will use polling mode
Date: Sun, 16 Nov 2008 07:31:35 -0800
Cc: Alexey Starikovskiy <aystarik@gmail.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ACPI <linux-acpi@vger.kernel.org>, Len Brown <lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cool,
Then I'll just leave it as is
And move on to other tasks that I have. Thanks for the info and help

Regards;

justin P. Mattock



On Nov 16, 2008, at 4:44 AM, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Sunday, 16 of November 2008, Alexey Starikovskiy wrote:
>> Justin P. Mattock wrote:
>>> Well; reverting:
>>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=06cf7d3c7af902939cd1754abcafb2464060cba8
>>> is keeping the system from having a gpe storm
>>> (for at least four hours now);
>>> haven't had a chance to drain the battery and see
>>> the affects from that scenario.
>>>
>>>
>> Justin, by decreasing threshold, we just change how often  
>> _detection_ of
>> the storm fires, not the storm itself.
>
> Yes, I think what happens is that we just detect the interrupt storm  
> with the
> lower threshold, so the storm occured anyway previously, but it went  
> unnoticed
> (not necessarily a good thing).
>
> There is nothing to worry about as long as the box works as expected.
>
> Thanks,
> Rafael
