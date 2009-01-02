Return-Path: <linux-kernel-owner+w=401wt.eu-S1757333AbZABPK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333AbZABPK2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 10:10:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbZABPKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 10:10:19 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:29375 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbZABPKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 10:10:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Np8Se47kpPobbKaI4giilclzGL/2KL2IJEPnogGU0IQfF087xlbyTF5dj3Abyh+NMk
         Zo5Tq6QM+23YJq++hbVThAQwalXPW8p4nc53TpCrqpyER732ie6GUH7HwRA48vom2dOm
         BHACS+mkGtoaLkE2S9DBQYg3xZi6cuOeFI0qA=
Message-ID: <3f9a31f40901020710h508bbfbch3d7ccd6f4898ea03@mail.gmail.com>
Date: Fri, 2 Jan 2009 20:40:16 +0530
From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: x86 (Linux Tiny): configure out support for some processors
Cc: "Bryan Donlan" <bdonlan@gmail.com>, "Ingo Brueckl" <ib@wupperonline.de>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20090102093801.GD1975@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <495d2974@wupperonline.de>
	 <3e8340490901012119i40971452q9f938702e58d7532@mail.gmail.com>
	 <3f9a31f40901012159l255b95a8he41a341f36ebc54e@mail.gmail.com>
	 <20090102093801.GD1975@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 2, 2009 at 3:08 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:
>>
>> I think EMBEDDED is a misnomer for using CONFIG_PROCESSOR_SELECT and
>> should be used for more specific to Embedded stuff like for Embedded
>> range of CPUs or Embedded Systems.
>
> i think EMBEDDED is justified in this particular case, as enabling
> CONFIG_PROCESSOR_SELECT allows you to create truly CPU-incompatible
> kernels. Kernels that panic on bootup on contemporary CPUs that happen to
> have a different manufacturer.
>

EMBEDDED leads to following options :
Configure standard kernel features (for small systems)
[*]   Enable 16-bit UID system calls (NEW)
[*]   Sysctl syscall support (NEW)
[*]   Load all symbols for debugging/ksymoops (NEW)
[*]     Include all symbols in kallsyms
[*]       Strip machine generated symbols from kallsyms
[*]     Do an extra kallsyms pass
[*]   Support for hot-pluggable devices (NEW)
[*]   Enable support for printk (NEW)

and these are perfect options for Embedded.

But selection of the PROCESSOR based on EMBEDDED is not a good logic.

CONFIG_PROCESSOR_SELECT should be an independent and by default should
select all related CPUs but user can specify its own CPU if he wants.

If I know what is my CPU there is no point for supporting all related
CPUs in my kernel.

This needs to be fixed.

Thank you,

JSR.
