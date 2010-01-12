Return-Path: <linux-kernel-owner+w=401wt.eu-S1753761Ab0ALIrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab0ALIrI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 03:47:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379Ab0ALIrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 03:47:07 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:35869 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302Ab0ALIrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 03:47:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=pZwbxUqBjVXnBDA8cNoZjsePEDCiQBjV4Li6bTRN3gx3JWOloEbaTWj6xVr63tdXRk
         Vz2qLdfhA4+IBcWP6+w2GZHGHrv9NEvXRTdtrxKFRIZtiIw7Ni6vV8dsKwn350WFwChL
         YwK3AfhigbrgjvmiowV38De0Xi2G2aBlLnKLg=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1001111913570.17145@localhost.localdomain>
References: <1263264483-3959-1-git-send-email-yinghai@kernel.org>
	 <1263264483-3959-2-git-send-email-yinghai@kernel.org>
	 <alpine.LFD.2.00.1001111913570.17145@localhost.localdomain>
Date: Tue, 12 Jan 2010 00:47:03 -0800
X-Google-Sender-Auth: b506794aa5c6e6f1
Message-ID: <86802c441001120047v5c303dfdh648ad8ebf2f538c1@mail.gmail.com>
Subject: Re: [RFC PATCH 3/4] x86: using logical flat for amd cpu too.
From: Yinghai Lu <yinghai@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "ananth@in.ibm.com" <ananth@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11, 2010 at 7:16 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Mon, 11 Jan 2010, Yinghai Lu wrote:
>>
>> tested that amd support logical flat too when cpus num <= 8 and even
>> bsp apic id > 8
>>
>> so could remove vendor check...
>
> At least this one makes code simpler.
>
> What was the background for thinking that AMD didn't support the same APIC
> addressing models? If there really is some issue external to the CPU's
> themselves, whatever problem was attributed to AMD might be the same (or
> similar) problem that Ananth had.

not sure.

i remembered that bios fix one apic dest apic id in ioapic register.
before that that field
is set to 0 always.

YH
