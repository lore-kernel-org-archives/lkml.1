Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839AbYK0Vy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbYK0Vy0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 16:54:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753740AbYK0VyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 16:54:17 -0500
Received: from mail-gx0-f11.google.com ([209.85.217.11]:45752 "EHLO
	mail-gx0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648AbYK0VyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 16:54:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=XCSxeVkdOSYn9RfelwV4AjM+L7KuAZe9cU9Iq3FASa5Yj6FRcZIai5GIKQvCrFuMUq
         T/0iQRvmrTFTrGzmUKgnhmC3hOeOLNyXYErhLTYpfT+Hy3ERcpLWQrPsGyAq1NS1J9Zn
         E4QqAT7uvyi/vJe5X01h/xEvtnChpyZxv4O2A=
Message-ID: <b637ec0b0811271354l58fc6039m941ca37fb9173d5b@mail.gmail.com>
Date: Thu, 27 Nov 2008 22:54:14 +0100
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Regression in 2.6.28-rc and 2.6.27-stable - hibernate related
Cc: "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jay Fenlason" <fenlason@redhat.com>
In-Reply-To: <b637ec0b0811270717t360ce5f9j3d48e8a007010b0e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b637ec0b0811230817x5b445a0m665305d2b6bf6c1f@mail.gmail.com>
	 <b637ec0b0811261145q3c7af010l1db0480d13b41715@mail.gmail.com>
	 <492DAC81.4020803@s5r6.in-berlin.de> <200811270002.29537.rjw@sisk.pl>
	 <b637ec0b0811270717t360ce5f9j3d48e8a007010b0e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, Nov 27, 2008 at 4:17 PM, Fabio Comolli <fabio.comolli@gmail.com> wrote:
> Hi
>
> On Thu, Nov 27, 2008 at 12:02 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> Actually, yes, Fabio, you can try to revert all of the "ACPI: EC:" commits
>> applied after 2.6.27.4 and retest.
>
> Will do tonight. I see that there are some other "ACPI: EC:" commits
> in 2.6.27.6 and 2.6.27.7.
>
> I'l just compile the ec.c file from 2.6.27.4 in 2.6.27.7 and test if
> the three commits introduced in 2.6.27.5 wouldn't revert cleanly,
>
> By the way, my HD passed a "smartctl -t long" test without any problems.
>

Reproduced with 2.6.27.7 with ec.c taken from 2.6.27.4 - after three
minutes of freeze the laptop came back to normal as nothing had
happened.

>>
>> Thanks,
>> Rafael
>>

Regards,
Fabio
