Return-Path: <linux-kernel-owner+w=401wt.eu-S1758195AbYFQRwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195AbYFQRwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 13:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755100AbYFQRwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 13:52:44 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:39177 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992AbYFQRwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 13:52:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IiX9Hb45BODnpfYq1UHPzNEKdUgh2lXXl+znFYnr8YK8/uU5Uwi9s1pM6dc5i9ZZ7p
         rut6E1WtByJvYywH8tbP75Ovmzcj2HMR5xvHGj13hVdQD5wjoaUa1O2T09rnKFIxf0b+
         3gUpxHmJSiFBYj7rx6LTiN0xBlidR9UxGgXxI=
Message-ID: <86802c440806171052n6221d13dnf172928b0321dc6a@mail.gmail.com>
Date: Tue, 17 Jun 2008 10:52:42 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: merge setup_memory_map with e820
Cc: "Glauber Costa" <glommer@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4857F6B5.4000404@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806161303.31997.yhlu.kernel@gmail.com>
	 <200806161958.28627.yhlu.kernel@gmail.com>
	 <5d6222a80806170531g50a72ea2r963bba8e404e619f@mail.gmail.com>
	 <4857E07F.3070209@zytor.com>
	 <86802c440806170918l1cb10014nccfd8d3e2b13da47@mail.gmail.com>
	 <4857F6B5.4000404@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2008 at 10:39 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> Yinghai Lu wrote:
>>
>> that is behavoir before merge.
>>
>>> Uhm... x86-64 and HIGHMEM are mutually exclusive.
>>>
>>> Either way, it shouldn't be dependent on anything; there is no reason why
>>> the #else clause can't be applied to both.
>>
>> remove the early_panic?
>>
>
> Yes, remove the early_panic().  Andi didn't want to support the non-e820
> modes in x86-64, but if the code is unified there is no reason not to.


OK, after Ingo put three patch in the tip, I will submit one to remove
early_panic.

YH
