Return-Path: <linux-kernel-owner+w=401wt.eu-S1758253AbZABRLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758253AbZABRLI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 12:11:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757118AbZABRKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 12:10:54 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:42990 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757047AbZABRKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 12:10:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xVoRQBeo+0+UgI0llN1YwL3GGs1KW8eFo42Nnk8O8RLu3n/LL35LNUiw6w71ad3+3R
         TXQzBc7ZKWVyCKUMrp6kqIm0K6gzAOSz/8ntxSF8cEHe9Sw/z6Es1pb1ZvfQsrquPmXC
         ys0L8u9x06/ZLKZQXTmcBtagRlFD8YQmmmeOk=
Message-ID: <a00b9da20901020910i2625073av96ce68ec0c313a8c@mail.gmail.com>
Date: Fri, 2 Jan 2009 18:10:50 +0100
From: "Frank Groeneveld" <frankgroeneveld@gmail.com>
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: Kernel 2.6.28 regression: Hang after hibernate
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20090102162220.GB1555@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a00b9da20812281234u76da2ef5tb715f4c409eaf37c@mail.gmail.com>
	 <20090102162220.GB1555@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With minimum config you mean only the most necessary drivers (like
disabling ALSA)?
I will try a kernel without SMP.

Frank

2009/1/2 Pavel Machek <pavel@suse.cz>:
> Hi!
>
>> Today I tried the new kernel and found out it has a regression. With
>> kernel 2.6.27 I never had problems resuming from hibernate, but with
>> 2.6.28 it hangs. The output is something like this (it's not exactly,
>> I skipped some words that are before the PCI lines):
>>
>> PM: read .. MB in .. seconds
>> SDA: Synchronizing SCSI cache
>> r8169: PME# enabled
>> PCI INT A disabled
>> PCI INT D disabled
>> PCI INT B disabled
>> PCI INT C disabled
>> PCI INT D disabled
>> PCI INT A disabled
>> Disabling non-boot CPUs
>> CPU1 is now offline
>> CPU1 is down
>> CPU2 is now offline
>> CPU2 is down
>> CPU3 is now offline
>> CPU3 is down
>> SMP Alternatives: switching to UP code
>>
>> I first thought it's the same as bug 12155, but I'm not sure it is.
>> If there's any other ouput I can send to help, let me know.
>
> Can you try with minimum config? And maybe !CONFIG_SMP?
>                                                                        Pavel
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>
