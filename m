Return-Path: <linux-kernel-owner+w=401wt.eu-S1755618AbYK0PRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618AbYK0PRX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 10:17:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbYK0PRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 10:17:15 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:28397 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbYK0PRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 10:17:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jhviSCsIUmcm/lTHsMurqbJqS/kUQhBkf8ATuRTc8RaZmPLKp82iR9rAv4TQvDQqZN
         BHZOGxA7xk0N1vGefeqXEZC+R2wkboPWIhcc/9AAhTcPky6vYV+VaGe3dVhetKVLSXvk
         xBcu//67YPZTba22YWvSTO2moB/H4z2LB+DGc=
Message-ID: <b637ec0b0811270717t360ce5f9j3d48e8a007010b0e@mail.gmail.com>
Date: Thu, 27 Nov 2008 16:17:13 +0100
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Regression in 2.6.28-rc and 2.6.27-stable - hibernate related
Cc: "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jay Fenlason" <fenlason@redhat.com>
In-Reply-To: <200811270002.29537.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b637ec0b0811230817x5b445a0m665305d2b6bf6c1f@mail.gmail.com>
	 <b637ec0b0811261145q3c7af010l1db0480d13b41715@mail.gmail.com>
	 <492DAC81.4020803@s5r6.in-berlin.de> <200811270002.29537.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, Nov 27, 2008 at 12:02 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Wednesday, 26 of November 2008, Stefan Richter wrote:
>>
>> The 2.6.27.5 changelog shows a bunch of ACPI changes.  They may not be
>> responsible, but in my uninformed opinion these are the changes to look
>> at more closely.  Since plain bisection did not work well for you, maybe
>> you should ask the maintainers involved in the ACPI patches for a
>> priority list of patches to unapply for long-term tests.
>
> Actually, yes, Fabio, you can try to revert all of the "ACPI: EC:" commits
> applied after 2.6.27.4 and retest.

Will do tonight. I see that there are some other "ACPI: EC:" commits
in 2.6.27.6 and 2.6.27.7.

I'l just compile the ec.c file from 2.6.27.4 in 2.6.27.7 and test if
the three commits introduced in 2.6.27.5 wouldn't revert cleanly,

By the way, my HD passed a "smartctl -t long" test without any problems.

>
> Thanks,
> Rafael
>

Regards,
Fabio
