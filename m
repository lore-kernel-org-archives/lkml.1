Return-Path: <linux-kernel-owner+w=401wt.eu-S1756779AbYH3TtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779AbYH3TtQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 15:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754310AbYH3TtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 15:49:00 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:51191 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979AbYH3Ts7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 15:48:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=E8a30FrcvWJRSa93bVW5QfzG3UBk17bcyDVy9N2kHDf20adf/7F1pP4B/HS1C+855p
         wNW0OErM0130jM6t1j23pgCY7JyuC5ln6Yb9xh2OImvazfUC1IUC777mqaYFISOTx/LN
         fbQzGz+Xoyk+fWj0W6EKmt3VH11p9JE3VL2gc=
Message-ID: <86802c440808301248l71d13c2duc6e56e2475522cb9@mail.gmail.com>
Date: Sat, 30 Aug 2008 12:48:58 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Tejun Heo" <htejun@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "David Witbrodt" <dawitbro@sbcglobal.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Kernel Testers" <kernel-testers@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0808301238390.3290@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>
	 <200808292157.24179.rjw@sisk.pl>
	 <alpine.LFD.1.10.0808291434110.3300@nehalem.linux-foundation.org>
	 <200808300030.32905.rjw@sisk.pl>
	 <alpine.LFD.1.10.0808301012060.3290@nehalem.linux-foundation.org>
	 <86802c440808301107n4561e815ldf53183c92a7bc93@mail.gmail.com>
	 <alpine.LFD.1.10.0808301141590.3290@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0808301150150.3290@nehalem.linux-foundation.org>
	 <86802c440808301226h1e7a9bb6g721ecdb0f93c5220@mail.gmail.com>
	 <alpine.LFD.1.10.0808301238390.3290@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2008 at 12:41 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Sat, 30 Aug 2008, Yinghai Lu wrote:
>>
>> AMD CPU/NB (quad core aka fam 10h later) has MSR to state MMCONFIG, and
>>  the ATI bridge BAR that have same address for MMCONFIG not even have
>> chance to decode that, because NB intercept that already.
>
> Ok, so it's similar to the local APIC in that respect (and presumably IO
> APIC too, I haven't checked).
>
> But that still just implies that the BAR probably means something else
> totally, and the fact that it happens to have the same value as the MCFG
> is just random luck.
>
>> it seems ATI chipset doesn't have public version of doc...like reg
>> info and BIOS/Kernel porting guide.
>
> Yeah, I'm not finding anything either. The 690G databook that Rafael
> pointed to does mention the config registers in passing, but it's really
> just about electricals (pin setup etc). No BIOS writers guide indeed..

Those BIOS porting guide need extra NDA...
they don't want to everyone know that there is lots workaround for
their silicon bugs.

YH
