Return-Path: <linux-kernel-owner+w=401wt.eu-S1757809AbZDWRpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757809AbZDWRpV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 13:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754330AbZDWRpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 13:45:05 -0400
Received: from yw-out-2122.google.com ([74.125.46.27]:26711 "EHLO
	yw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbZDWRpE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 13:45:04 -0400
MIME-Version: 1.0
Date: Thu, 23 Apr 2009 10:45:03 -0700 (PDT)
In-Reply-To: <fa.p4mWFgWCFwhnKR83MseIShfc6uQ@ifi.uio.no>
X-IP: 164.116.126.146
References: <fa.LVGNb1leZ16O2EUrcLYbCwtL9mc@ifi.uio.no> <fa.DPrbiibT7M43HJi+nTdM88e1eOQ@ifi.uio.no> 
	<fa.p4mWFgWCFwhnKR83MseIShfc6uQ@ifi.uio.no>
User-Agent: G2/1.0
X-HTTP-UserAgent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_6; en-us) 
	AppleWebKit/525.18.1 (KHTML, like Gecko) Version/3.1.2 Safari/525.20.1,gzip(gfe),gzip(gfe)
Message-ID: <fb0aeafb-a24b-413f-8d74-19c28de7faff@u9g2000pre.googlegroups.com>
Subject: Re: I/O APIC: Timer through 8259A revamp
From: yuhong <yuhongbao_386@hotmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  The new burst of breakage came with the invention of ACPI and its tables
> for interrupt routing for the APIC.
Yep, when NVIDIA and ATI entered the chipset market, who would have
predicted that it would cause more 8254 and APIC related troubles? Or
it would be years before it were finally fixed properly? Even worse,
ATI made chipsets before AMD and Intel introduced their 64-bit CPUs,
yet it was the x86-64 architecture where the attempts to fix the ATI
APIC 8254 timer issues were going to. Only later when it was finally
fixed properly was it backported to x86.
