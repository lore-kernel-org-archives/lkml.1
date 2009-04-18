Return-Path: <linux-kernel-owner+w=401wt.eu-S1755019AbZDRVZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbZDRVZF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 17:25:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbZDRVYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 17:24:54 -0400
Received: from mail-bw0-f211.google.com ([209.85.218.211]:37385 "EHLO
	mail-bw0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbZDRVYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 17:24:53 -0400
X-Greylist: delayed 409 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Apr 2009 17:24:52 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FyHdzXd6HHHbLdiS0SgiWciqGuWRmjkKiZ0ALpy850IR1zWiY4+S4PaXLlHI8R5gyw
         hnj/7kPr8iJd4/Bl4/BAqOrrWr24bIhdUERtSdL13nIllaxPBKSCsr7aHorSGdJ/ZXJa
         qXQKzVzFtriddpfT+tUJHotL7n80dqNhTZSpY=
MIME-Version: 1.0
In-Reply-To: <49EA4189.9040204@kernel.org>
References: <20090418194528.GD25510@lenovo>
	 <tip-1f51f72326c4d16f402bdfed99c8dae20eb67863@git.kernel.org>
	 <49EA4189.9040204@kernel.org>
Date: Sun, 19 Apr 2009 01:18:02 +0400
Message-ID: <aa79d98a0904181418h433d2fcds129c60d4586b0940@mail.gmail.com>
Subject: Re: [tip:x86/apic] x86: smpboot - wakeup_secondary should be done via 
	__cpuinit section
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/19/09, Yinghai Lu <yinghai@kernel.org> wrote:
> tip-bot for Cyrill Gorcunov wrote:
>> Commit-ID:  1f51f72326c4d16f402bdfed99c8dae20eb67863
>> Gitweb:
>> http://git.kernel.org/tip/1f51f72326c4d16f402bdfed99c8dae20eb67863
>> Author:     Cyrill Gorcunov <gorcunov@gmail.com>
>> AuthorDate: Sat, 18 Apr 2009 23:45:28 +0400
>> Committer:  Ingo Molnar <mingo@elte.hu>
>> CommitDate: Sat, 18 Apr 2009 22:58:58 +0200
>>
>> x86: smpboot - wakeup_secondary should be done via __cpuinit section
>>
>> A caller (do_boot_cpu) already has __cpuinit attribute.
>>
>> Since HOTPLUG_CPU depends on SMP && HOTPLUG it doesn't
>> lead to panic at moment.
>>
>> [ Impact: cleanup ]
>>
>> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
>> LKML-Reference: <20090418194528.GD25510@lenovo>
>> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>>
>>
>> ---
>>  arch/x86/kernel/smpboot.c |    4 ++--
>
> there are other two in numaq and es7000.
>
> can you fix them too?
>
> YH
>
>
Will do tomorrow morning
