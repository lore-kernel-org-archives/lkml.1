Return-Path: <linux-kernel-owner+w=401wt.eu-S1763187AbYCFTXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763187AbYCFTXX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 14:23:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755403AbYCFTXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 14:23:14 -0500
Received: from rn-out-0910.google.com ([64.233.170.185]:54694 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807AbYCFTXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 14:23:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dJhChshNPcKOfAV80atgRXUmACUw6taNtEho8WQ7IfDAc4VF+62hFtrY4MnQYT+w0DLQ9KizGq9aiXfP+/voIbDm9cxLTXD7ClHlOwvAPV5K114TB2zD1fKdXCXm9Wg8k5FYjiMGMKZr9JilKdbhDOgrRDESf0gcNvp7WoiS7FU=
Message-ID: <86802c440803061123h2f2232d4jca7b81d7d2e4ca66@mail.gmail.com>
Date: Thu, 6 Mar 2008 11:23:09 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] x86_64: show apicid for cpu in proc
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <8763w0gjut.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440803060113s5b09c8b7w3a9da92ca15eff03@mail.gmail.com>
	 <8763w0gjut.fsf@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06 Mar 2008 12:41:46 +0100, Andi Kleen <andi@firstfloor.org> wrote:
> "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
>
>  >                          cpus_weight(per_cpu(cpu_core_map, cpu)));
>  >               seq_printf(m, "core id\t\t: %d\n", c->cpu_core_id);
>  >               seq_printf(m, "cpu cores\t: %d\n", c->booted_cores);
>
> > +             seq_printf(m, "apicid\t: %02x\n", c->apicid);
>
>  Seems a little redundant with the boot log, but ok.
>
>  But it's unclear to the user which apic ID is meant by that. There are
>  two different ones. The one in the LAPIC mapping and the one reported by
>  CPUID. They are not necessarily the same. I think you should clarify that
>  by renaming the field or perhaps report both.

report the apicid and initial apicid at the same time?

but in current code, we didn't use the initial apicid...., actually
initial apic id is more better to get the responding to node/core.

will look at it.

YH
