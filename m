Return-Path: <linux-kernel-owner+w=401wt.eu-S1751070AbZFFEWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751070AbZFFEWq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 00:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750750AbZFFEWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 00:22:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:44786 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbZFFEWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 00:22:39 -0400
Subject: Re: [PATCH -tip] x86: cpu/proc.c adding extended_cpuid_level for
 /proc/cpuinfo
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4A29862D.6030601@zytor.com>
References: <1242112482.3283.1.camel@localhost.localdomain>
	 <20090512232122.61f2d7c5.akpm@linux-foundation.org>
	 <1244227115.2507.3.camel@ht.satnam>  <4A29862D.6030601@zytor.com>
Content-Type: text/plain
Date: Sat, 06 Jun 2009 09:53:45 +0530
Message-Id: <1244262225.2449.22.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-05 at 13:55 -0700, H. Peter Anvin wrote:
> Jaswinder Singh Rajput wrote:
> > Hello Andrew,
> > 
> > On Tue, 2009-05-12 at 23:21 -0700, Andrew Morton wrote:
> >> On Tue, 12 May 2009 12:44:42 +0530 Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> >>
> >>> +		   "ext cpuid level\t: 0x%x\n"
> >> It's unobvious what "ext" means.  External?
> >>
> >> Can we make it "extended cpuid level"?
> > 
> > extended cpuid level will look like this :
> > 
> > fpu		: yes
> > fpu_exception	: yes
> > cpuid level	: 5
> > wp		: yes
> > extended cpuid level: 0x80000008
> > flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe constant_tsc pebs bts pni dtes64 monitor ds_cpl cid
> > 
> 
> The more I'm thinking about this I think it was a mistake to put cpuid
> level: there in the first place, too.  My opinion is increasingly to
> leave this to x86info or other user-space tools.
> 

cpuid level is as important as cpu family, model and stepping.

For Intel, in some cases cpuid level is more important then cpu family,
model and stepping. Like you cannot tell by looking at cpu family, model
and stepping which model is new and which is old like 05_01 or 06_1A or
0F_03H ?

But by looking at cpuid level and extended cpuid level you can tell
which is new and which is old and which supports more features.

So cpuid level and extended cpuid level is better scale than cpu family,
model and stepping. So I think hiding this valuable information is a
crime.

Thanks,
--
JSR


