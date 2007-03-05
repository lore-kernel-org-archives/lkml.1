Return-Path: <linux-kernel-owner+w=401wt.eu-S965257AbXCEN0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965257AbXCEN0F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 08:26:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965131AbXCEN0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 08:26:05 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:46265 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965257AbXCEN0D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 08:26:03 -0500
X-IronPort-AV: i="4.14,249,1170651600"; 
   d="scan'208"; a="23568348:sNHT23949114"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Paul Mundt" <lethal@linux-sh.org>
Subject: Re: [PATCH -mm 1/5] Blackfin: blackfin architecture patch update
Date: Mon, 5 Mar 2007 08:26:56 -0500
User-Agent: KMail/1.9.5
Cc: "Bernd Schmidt" <bernds_cb1@t-online.de>,
       "Wu, Bryan" <bryan.wu@analog.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <1172722480.5264.75.camel@roc-desktop> <45EC0DC7.8080504@t-online.de> <20070305123910.GA13684@linux-sh.org>
In-Reply-To: <20070305123910.GA13684@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703050826.56966.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 05 Mar 2007 13:26:00.0971 (UTC) FILETIME=[D118CDB0:01C75F29]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 5 Mar 2007 07:39, Paul Mundt pondered:
> On Mon, Mar 05, 2007 at 01:32:07PM +0100, Bernd Schmidt wrote:
>  > Paul Mundt wrote:
>  > >>+comment "Memory Optimizations"
>  > >>+
>  > >>+config I_ENTRY_L1
>  > >>+   bool "Locate interrupt entry code in L1 Memory"
>  > >>+   default y
>  > >>+   help
>  > >>+     If enabled interrupt entry code (STORE/RESTORE CONTEXT) is
>  > >> linked +     into L1 instruction memory.(less latency)
>  > >>+
>  > >
>  > >Wow, this is really crying out for a special linker section with
>  > > slightly more intelligent relocation logic. You should flag the
>  > > performance critical parts to be located in L1 memory directly with a
>  > > section attribute, rather than making everything selectable. If you
>  > > overflow you can simply spill in to main memory.
>  >
>  > This is done intentionally, because it's also possible for user code to
>  > be loaded into L1 memory.  We want to give users the option to avoid
>  > filling it all up with kernel code.
>
>  So then why not make the userspace component of it optional and allow a
> size cap for kernel usage that's configurable if it's enabled? This degree
> of abstraction is almost worse than no abstraction.

I don't understand why you think lots of options are a bad thing??

For most embedded targets, people want/need easy knobs to turn to try and 
optimise the system level performance. I would guess that SH users want to do 
the same thing?

That is what this does - it is just a easy to use knob.

-Robin
