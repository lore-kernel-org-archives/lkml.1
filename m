Return-Path: <linux-kernel-owner+w=401wt.eu-S1753190AbZDMSev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbZDMSev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 14:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbZDMSem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 14:34:42 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:41530 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbZDMSek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 14:34:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=Brd6C0cvV8RDgIKAhYKAAy3xZo2tukRxOMNYcU3Ri1UlEiq+ey4PHGwvXLt++9Ojqv
         eQyaNcCYMYHmsbvTG+QNUemdCrQ5oUEcVu/NyvkYNq/ruoIUhygPOHXzGZQ2Qbq8XFXJ
         W+/hdimI7Nsrh5/hXeqJ4OW9+HRbL1SRlbMtQ=
MIME-Version: 1.0
Reply-To: alan-jenkins@tuffmail.co.uk
In-Reply-To: <49E367E8.7080202@zytor.com>
References: <20090410103934.GA21506@elte.hu>
	 <20090410113824.GA18823@elf.ucw.cz> <49E0C1AB.2050608@redhat.com>
	 <49E17A6E.5000104@zytor.com>
	 <alpine.LFD.2.00.0904120754240.4583@localhost.localdomain>
	 <20090412163356.GA2392@elte.hu> <49E2398A.3050405@redhat.com>
	 <20090413041625.GF11652@elte.hu> <20090413042459.GA6479@elte.hu>
	 <49E367E8.7080202@zytor.com>
Date: Mon, 13 Apr 2009 19:34:39 +0100
Message-ID: <9b2b86520904131134y26f508ffr2bc0303eff203a25@mail.gmail.com>
Subject: Re: [tip:x86/setup] x86, setup: "glove box" BIOS calls -- 
	infrastructure
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
       rjw@sisk.pl, linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/13/09, H. Peter Anvin <hpa@zytor.com> wrote:
> Ingo Molnar wrote:
>>> Yes, we could do memory checks, and ... hey, we already do that:
>>>
>>>    bb577f9: x86: add periodic corruption check
>>>    5394f80: x86: check for and defend against BIOS memory corruption
>>>
>>> ... and i seem to be the one who implemented it! ;-)
>>
>> s/implemented/merged+fixed :-)
>
> Actually, what would probably be more productive than trying to track
> corruption would be to drop the low 1 MB of memory before suspend to RAM
> - make sure that it is as close to completely unused as possible.
>
> All *known* cases of low memory corruption are either boot time or due
> to s2ram.

IIRC, the first person to report the issue found that it triggered
when hotplugging a HDMI cable.
