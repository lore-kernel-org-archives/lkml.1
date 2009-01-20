Return-Path: <linux-kernel-owner+w=401wt.eu-S1758217AbZATWfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217AbZATWfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 17:35:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbZATWfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 17:35:36 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:23308 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbZATWff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 17:35:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DsRFAnMHRnewuzQevFPnW/HGGxzurXWOA4JWvVN81q7oRPuJ6JGbW8tjaZD2jGegcj
         qKlnqM1QYEmFvfUvG2LUb9QzdgoB5EFWcj9wIADzDoJENvZskFxF4pePfeOEmSSngy/h
         BawzKMwXv50z8fV/Y3EgFodoOYGDmm33vxOxk=
Message-ID: <81b0412b0901201435mabecad3i66957a6463140b82@mail.gmail.com>
Date: Tue, 20 Jan 2009 23:35:32 +0100
From: "Alex Riesen" <raa.lkml@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [Bug #12468] Crash in acpi_cpufreq_init
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Alex Riesen" <fork0@users.sf.net>
In-Reply-To: <20090120142312.GB10224@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <0GOi9pntEoL.A.iGF.B9QdJB@chimera>
	 <2QN7KFic7LG.A.sgH.t9QdJB@chimera>
	 <81b0412b0901191633y130c4cf0w5531af81c3749ee2@mail.gmail.com>
	 <20090120142312.GB10224@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/20 Ingo Molnar <mingo@elte.hu>:
>
> * Alex Riesen <raa.lkml@gmail.com> wrote:
>
>> 2009/1/19 Rafael J. Wysocki <rjw@sisk.pl>:
>> > This message has been generated automatically as a part of a report
>> > of recent regressions.
>> >
>> > The following bug entry is on the current list of known regressions
>> > from 2.6.28.  Please verify if it still should be listed and let me know
>> > (either way).
>> >
>>
>> The regression is still present.
>
> should be fixed by the pending x86 fixes:
>
>   git pull git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus
>
> does it work fine if you pull that tree?

Yep. No crashing anymore. The commits starting from 31ad908 (work_on_cpu...)
seem to do the fixing.
