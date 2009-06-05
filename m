Return-Path: <linux-kernel-owner+w=401wt.eu-S1753055AbZFEShj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbZFEShj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 14:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbZFEShc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 14:37:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:59615 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbZFEShb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 14:37:31 -0400
Subject: Re: [PATCH -tip] x86: cpu/proc.c adding extended_cpuid_level for
 /proc/cpuinfo
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090512232122.61f2d7c5.akpm@linux-foundation.org>
References: <1242112482.3283.1.camel@localhost.localdomain>
	 <20090512232122.61f2d7c5.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sat, 06 Jun 2009 00:08:35 +0530
Message-Id: <1244227115.2507.3.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew,

On Tue, 2009-05-12 at 23:21 -0700, Andrew Morton wrote:
> On Tue, 12 May 2009 12:44:42 +0530 Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > +		   "ext cpuid level\t: 0x%x\n"
> 
> It's unobvious what "ext" means.  External?
> 
> Can we make it "extended cpuid level"?

extended cpuid level will look like this :

fpu		: yes
fpu_exception	: yes
cpuid level	: 5
wp		: yes
extended cpuid level: 0x80000008
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe constant_tsc pebs bts pni dtes64 monitor ds_cpl cid

Is this OK ?

Thanks,
--
JSR

