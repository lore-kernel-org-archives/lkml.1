Return-Path: <linux-kernel-owner+w=401wt.eu-S1756685AbZDWSAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbZDWSAv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 14:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbZDWSAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 14:00:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33257 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbZDWSAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 14:00:41 -0400
Date: Thu, 23 Apr 2009 20:04:19 +0200
From: Andi Kleen <andi@firstfloor.org>
To: yuhong <yuhongbao_386@hotmail.com>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: I/O APIC: Timer through 8259A revamp
Message-ID: <20090423180419.GT13896@one.firstfloor.org>
References: <fa.LVGNb1leZ16O2EUrcLYbCwtL9mc@ifi.uio.no> <fa.DPrbiibT7M43HJi+nTdM88e1eOQ@ifi.uio.no> <fa.p4mWFgWCFwhnKR83MseIShfc6uQ@ifi.uio.no> <fb0aeafb-a24b-413f-8d74-19c28de7faff@u9g2000pre.googlegroups.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fb0aeafb-a24b-413f-8d74-19c28de7faff@u9g2000pre.googlegroups.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 10:45:03AM -0700, yuhong wrote:
> >  The new burst of breakage came with the invention of ACPI and its tables
> > for interrupt routing for the APIC.
> Yep, when NVIDIA and ATI entered the chipset market, who would have
> predicted that it would cause more 8254 and APIC related troubles? Or
> it would be years before it were finally fixed properly? Even worse,
> ATI made chipsets before AMD and Intel introduced their 64-bit CPUs,
> yet it was the x86-64 architecture where the attempts to fix the ATI
> APIC 8254 timer issues were going to. Only later when it was finally
> fixed properly was it backported to x86.

I'm not sure what you mean here. The ATI timer fixes were done
on both i386 and x86-64.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
