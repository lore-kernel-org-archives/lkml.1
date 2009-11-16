Return-Path: <linux-kernel-owner+w=401wt.eu-S1753465AbZKPRFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbZKPRFp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 12:05:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbZKPRFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 12:05:44 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:36083 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbZKPRFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 12:05:44 -0500
Date: Mon, 16 Nov 2009 09:05:07 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: tip tree build warning
Message-Id: <20091116090507.18abfa0f.randy.dunlap@oracle.com>
In-Reply-To: <20091116162503.7f083c3a.sfr@canb.auug.org.au>
References: <20091116162503.7f083c3a.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4B018652.014A:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Nov 2009 16:25:03 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Today's linux-next build (x86_64 allmodconfig) produced this warning:
> 
> arch/x86/kernel/apic/apic.c: In function 'calibrate_APIC_clock':
> arch/x86/kernel/apic/apic.c:650: warning: format '%ld' expects type 'long int', but argument 2 has type 'u32'
> 
> Introduced by commit 23af368e9a904f59256c27d371ce223d6cee0430
> ("clockevents: Use u32 for mult and shift factors").


also this warning:

arch/x86/kernel/vmiclock_32.c:230: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'u32'

(i386 build)

---
~Randy
