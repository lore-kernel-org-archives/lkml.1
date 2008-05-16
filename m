Return-Path: <linux-kernel-owner+w=401wt.eu-S1757581AbYEPMsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581AbYEPMsh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 08:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755358AbYEPMsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 08:48:17 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:64731 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755231AbYEPMsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 08:48:16 -0400
To: akataria@vmware.com
Cc: devzero@web.de, linux-kernel@vger.kernel.org, dhecht@vmware.com
Subject: Re: Kernel hangs in SMP + VMware environment.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1210789834.8798.20.camel@promb-2n-dhcp368.eng.vmware.com>
	<200805150611.m4F6Bv4J046219@www262.sakura.ne.jp>
	<D3C12B2AD838B44DA9D6B2CA334246D00D8F38DA60@PA-EXMBX04.vmware.com>
In-Reply-To: <D3C12B2AD838B44DA9D6B2CA334246D00D8F38DA60@PA-EXMBX04.vmware.com>
Message-Id: <200805162148.AAJ21381.QOSMOFFFLHOVJt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Fri, 16 May 2008 21:48:12 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Alok Kataria wrote:
> Actually it would be better to use clocksource=acpi_pm on kernels which don't
> have this patch, as ACPI_PM comes with many more featuers like hrtimers,
> nohz, etc.
> 
> On the other hand for kernels which have this patch attached,  it would be
> best to use TSC, for performance.
I see. Thanks.



I'm not sure, but this problem might exist in all kernels since 2.6.18 , for
I can find clocksource= parameter in Documentation/kernel-parameters.txt .

I didn't experience this problem in earlier kernels (e.g. 2.6.20)
since I was running only 1 VMware guest at a time.
Today I ran 2 VMware guests simultaneously (one with kernel 2.6.22 and
the other with kernel 2.6.18, both are assigned 2 virtual CPUs) and I encountered
may-be-hanged-up with the 2.6.18 one.
The Ctrl-C didn't work, the Alt-F? didn't work, the Ctrl-Alt-Del didn't work.
I had no time to reproduce it, so I'm not sure it has actually hanged up.

Regards.
