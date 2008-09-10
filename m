Return-Path: <linux-kernel-owner+w=401wt.eu-S1752512AbYIJA0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512AbYIJA0d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 20:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbYIJA0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 20:26:25 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:22407 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbYIJA0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 20:26:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=T2sFho0RGZH/Ru/npQ0ojZEIdPwYYjVNLVWoQfh7BpjlKUuXz4Tb2B7WDidbSU5i/V
         9hmSqgWi9bgrQEZDHXb+brHW5p+/YfJj2miQEUE8uZAMfc2KJQuPLPQ9wh1pdplBkSLQ
         02EpLm8J5RIhK9UO9JKcm6Lm9J3/q6bLAYE+c=
Message-ID: <86802c440809091726y4db8f85eg2d478b482862c5f9@mail.gmail.com>
Date: Tue, 9 Sep 2008 17:26:23 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: TARGET_CPUS in assign_irq_vector
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <48C70ADC.8060004@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48C6F913.1010509@goop.org>
	 <86802c440809091554y349366fdu8e4ca59797ab4205@mail.gmail.com>
	 <48C70ADC.8060004@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2008 at 4:46 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Yinghai Lu wrote:
>> target_cpus is the cpus that could be possible to used to take vector
>> and process that irq. so at least it should be online.
>>
>
> Would it be wrong to make it possible_cpu_mask?
>
it is wrong

YH
