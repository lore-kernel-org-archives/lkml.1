Return-Path: <linux-kernel-owner+w=401wt.eu-S1751482AbZEUGNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482AbZEUGNL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 02:13:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750924AbZEUGM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 02:12:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51166 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbZEUGM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 02:12:58 -0400
Message-ID: <4A14F0A1.3000605@kernel.org>
Date: Wed, 20 May 2009 23:11:45 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Robert Richter <robert.richter@amd.com>,
       Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 1/10 -tip] x86: Add cpufeature for Processor Name
References: <1242142530.2547.11.camel@ht.satnam> <1242142623.2547.13.camel@ht.satnam>
In-Reply-To: <1242142623.2547.13.camel@ht.satnam>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
> Processor Name / Brand String (Function 8000_0002h, 8000_0003h, 8000_0004h)
> Functions 8000_0002h, 8000_0003h, and 8000_0004h each return up to 16 ASCII
> bytes of the processor name in the EAX, EBX, ECX and EDX registers.
> 
> X86_FEATURE_PNAME will be useful for displaying MSRs like AMD:
> MSRC001_00[35:30] Processor Name String Registers
> 

Pointless and wrong.  The presence of the processor name is not the same
thing as the presence of specific MSRs, which are model-specific.

	-hpa
