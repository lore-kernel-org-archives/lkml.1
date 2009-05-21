Return-Path: <linux-kernel-owner+w=401wt.eu-S1753774AbZEUHjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774AbZEUHjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 03:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbZEUHjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 03:39:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:47078 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895AbZEUHjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 03:39:20 -0400
Subject: Re: [PATCH 1/10 -tip] x86: Add cpufeature for Processor Name
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Robert Richter <robert.richter@amd.com>,
       Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       x86 maintainers <x86@kernel.org>
In-Reply-To: <4A14F0A1.3000605@kernel.org>
References: <1242142530.2547.11.camel@ht.satnam>
	 <1242142623.2547.13.camel@ht.satnam>  <4A14F0A1.3000605@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 May 2009 13:08:30 +0530
Message-Id: <1242891510.8204.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-20 at 23:11 -0700, H. Peter Anvin wrote:
> Jaswinder Singh Rajput wrote:
> > Processor Name / Brand String (Function 8000_0002h, 8000_0003h, 8000_0004h)
> > Functions 8000_0002h, 8000_0003h, and 8000_0004h each return up to 16 ASCII
> > bytes of the processor name in the EAX, EBX, ECX and EDX registers.
> > 
> > X86_FEATURE_PNAME will be useful for displaying MSRs like AMD:
> > MSRC001_00[35:30] Processor Name String Registers
> > 
> 
> Pointless and wrong.  The presence of the processor name is not the same
> thing as the presence of specific MSRs, which are model-specific.
> 

>From AMD's BIOS and Kernel Developer’s Guide(BKDG) Manual :

 MSRC001_00[35:30] Processor Name String Registers
Reset: 0000 0000 0000 0000h. These registers holds the CPUID name string in ASCII. The state of these regis-
ters are returned by CPUID instructions, CPUID Fn8000_000[4:2]. BIOS should set these registers to the
AMD-provided product name for the processor. Each register contains a block of 8 ASCII characters; the least
byte corresponds to the first ASCII character of the block; the most-significant byte corresponds to the last
character of the block. MSRC001_0030 contains the first block of the name string; MSRC001_0035 contains
the last block of the name string.

  Bits    Description
  63:0 CpuNameString. Read-write.

--
JSR

