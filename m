Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbYC3UXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbYC3UXY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 16:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbYC3UXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 16:23:16 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:65308 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbYC3UXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 16:23:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DMvRNX2lqzl8KbXoziABdY+5f1UVX2uctlrPCwv5tRhPfCDmyiXo2oYIvgfvxjidSryaraxyIeibv1QKkHRG91VyQC3x4P4fuVef6LVYH4bpluYDV5BssfvZYqeimT80C9X2VO1zzyZNnIaxl7dqGHEC7gapz26HZyt8vqZZGr4=
Message-ID: <86802c440803301323q5c4bd4f4k1f9bdc1d6b1a0a7b@mail.gmail.com>
Date: Sun, 30 Mar 2008 13:23:12 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [RFC 8/8] x86_64: Support for new UV apic
Cc: "Jack Steiner" <steiner@sgi.com>, "Andi Kleen" <andi@firstfloor.org>,
       tglx@linutronix.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080326073823.GD3442@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080324182122.GA28327@sgi.com> <87abknhzhd.fsf@basil.nowhere.org>
	 <20080325175657.GA6262@sgi.com> <20080326073823.GD3442@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 12:38 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Jack Steiner <steiner@sgi.com> wrote:
>
>  > > > -        obj-y                            += genapic_64.o genapic_flat_64.o
>  > > > +        obj-y                            += genapic_64.o genapic_flat_64.o genx2apic_uv_x.o
>  > >
>  > > Definitely should be a CONFIG
>  >
>  > Not sure that I understand why. The overhead of UV is minimal & we
>  > want UV enabled in all distro kernels. OTOH, small embedded systems
>  > probably want to eliminate every last bit of unneeded code.
>  >
>  > Might make sense to have a config option. Thoughts????
>
>  i wouldnt mind having UV enabled by default (it can be a config option
>  but default-enabled on generic kernels so all distros will pick this hw
>  support up), but we definitely need the genapic unification before we
>  can add more features.

config option would be reasonable.
for x86_64
subarch already have X86_PC, X86_VSMP.
we have X86_UVSMP

YH
