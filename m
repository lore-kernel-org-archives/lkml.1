Return-Path: <linux-kernel-owner+w=401wt.eu-S1756049AbZAGN6D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbZAGN6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 08:58:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbZAGN5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 08:57:53 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:37580 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbZAGN5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 08:57:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=P5KyquUNewkBBf+31gCCl3y9oMBHuP2UxnbVJiydqm2pH19fKCGzFmTeoFzQEU5yi8
         GBHkRJZNNT4Er0QQJpTSzdWpCyMIm8hUAchkG5IJMXXPre4TpDU3W0hmPrdiRlEWsrPZ
         c38suI/cThlOQhBmDFAqlUxyjUmE9PGgin8Mg=
Message-ID: <3f9a31f40901070557r336020dctbe9549e8634b167@mail.gmail.com>
Date: Wed, 7 Jan 2009 19:27:51 +0530
From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH -tip 0/7] x86: move NON-SMP data from smp.h
Cc: "Jaswinder Singh Rajput" <jaswinder@infradead.org>,
       "x86 maintainers" <x86@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Andi Kleen" <andi@firstfloor.org>,
       James.Bottomley@hansenpartnership.com,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090107133327.GA4911@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1231329368.17961.29.camel@jaswinder.satnam>
	 <20090107125152.GA3529@elte.hu> <20090107133327.GA4911@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

On Wed, Jan 7, 2009 at 7:03 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>> applied to tip/x86/cleanups:
>
> excluded it again from tip/master, due to this build failure:
>

Please accept only first 4 patches:

1.  x86: smp.h remove obsolete function declaration
2.  x86: smp.h move zap_low_mappings declartion to tlbflush.h
3.  x86: smp.h move prefill_possible_map declartion to cpu.h
4.  x86: smp.h move stack_processor_id declartion to cpu.h

Then it will easier for me to to focus on only few things.

Thanks
--
JSR
