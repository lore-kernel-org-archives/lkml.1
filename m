Return-Path: <linux-kernel-owner+w=401wt.eu-S1762718AbXGPURT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762718AbXGPURT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 16:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbXGPURL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 16:17:11 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:4734 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbXGPURI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 16:17:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rNf9BHVoAdkcbrg8EGhhMGnBf4XLy4Lonmd5NbUgYQa7UgpE0hHU2FIJgvPKuWp/hnx5rHxnh+3Q1PLMFP65ylXtolSPIswoKpnVscXIFbybR5fbji8JNA5hsC8Bn4qUCCC1YTTa+W0zkyt6znp8/Ciwxm6DuFh89fY9O0/5I8k=
Message-ID: <3efb10970707161317h72b30aabq208150b2abde8e5e@mail.gmail.com>
Date: Mon, 16 Jul 2007 22:17:08 +0200
From: "Remy Bohmer" <l.pinguin@gmail.com>
Reply-To: linux@bohmer.net
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [Question] Hooks for scheduler tracing (CFS)
Cc: LKML <linux-kernel@vger.kernel.org>,
       RT-Users <linux-rt-users@vger.kernel.org>, mathieu.desnoyers@polymtl.ca,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <1184615557.2698.3.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3efb10970707161246se06ab22i32872cfe6fa4f2f6@mail.gmail.com>
	 <1184615557.2698.3.camel@laptopd505.fenrus.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Arjan,

Thanks for this suggestion.
But I looked at Systemtap before, and as I remember, it is very
flexible, but it only traces function calls. (or am I missing
something?)
I also need this scheduler-tracer, besides for fully fledged X86
systems, also for ARM based boards also with a very minimal userland,
and limited flash. So, it has to be lightweight also. I can only use
cross-compilers to build the tools... (something Systemtap is not good
at as I remember...)

So, I am missing something here, or it is unfortunately not what I am
looking for...


Kind Regards,

Remy


2007/7/16, Arjan van de Ven <arjan@infradead.org>:
> On Mon, 2007-07-16 at 21:46 +0200, Remy Bohmer wrote:
> > So I was wondering if anybody knows some tool/kernel mechanism which
> > can do this?
> > If not, I will build a kernel extension for it myself (new extension
> > to 'latency_trace' ?)
>
> systemtap has been able to do such things for me in the past...
>
> --
> if you want to mail me at work (you don't), use arjan (at)
> linux.intel.com
> Test the interaction between Linux and your BIOS via
> http://www.linuxfirmwarekit.org
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
