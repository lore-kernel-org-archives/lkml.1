Return-Path: <linux-kernel-owner+w=401wt.eu-S1753203AbZKWSGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbZKWSGV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 13:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbZKWSGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 13:06:21 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:28245 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbZKWSGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 13:06:20 -0500
Date: Mon, 23 Nov 2009 10:05:39 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: tip tree build warning
Message-Id: <20091123100539.bcdbd211.randy.dunlap@oracle.com>
In-Reply-To: <20091116090507.18abfa0f.randy.dunlap@oracle.com>
References: <20091116162503.7f083c3a.sfr@canb.auug.org.au>
	<20091116090507.18abfa0f.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4B0ACF05.0214:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Nov 2009 09:05:07 -0800 Randy Dunlap wrote:

> On Mon, 16 Nov 2009 16:25:03 +1100 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Today's linux-next build (x86_64 allmodconfig) produced this warning:
> > 
> > arch/x86/kernel/apic/apic.c: In function 'calibrate_APIC_clock':
> > arch/x86/kernel/apic/apic.c:650: warning: format '%ld' expects type 'long int', but argument 2 has type 'u32'
> > 
> > Introduced by commit 23af368e9a904f59256c27d371ce223d6cee0430
> > ("clockevents: Use u32 for mult and shift factors").
> 
> 
> also this warning:
> 
> arch/x86/kernel/vmiclock_32.c:230: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'u32'
> 
> (i386 build)


Thomas posted a patch for this, but I'm still seeing this warning (20091123),
so I guess his patch hasn't been merged/pushed yet?

thanks,
---
~Randy
