Return-Path: <linux-kernel-owner+w=401wt.eu-S1760565AbYEMUyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760565AbYEMUyw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752909AbYEMUyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:54:44 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:57006 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbYEMUyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:54:43 -0400
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>,
       Valdis.Kletnieks@vt.edu, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [BISECTED] Lots of "rescheduling IPIs" in powertop
From: Andi Kleen <andi@firstfloor.org>
References: <20080513204206.GA17781@damson.getinternet.no>
Date: Tue, 13 May 2008 22:54:40 +0200
In-Reply-To: <20080513204206.GA17781@damson.getinternet.no> (Vegard Nossum's message of "Tue, 13 May 2008 22:42:06 +0200")
Message-ID: <873aol9b73.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 May 2008 20:47:41.0651 (UTC) FILETIME=[966CEA30:01C8B53A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum <vegard.nossum@gmail.com> writes:
>
> This initially showed up on my 2.6.24.5-85.fc8 (Fedora) kernel.
>
> I have two different systems (one laptop, one desktop) which both show the
> same symptoms, please do tell me if you need any more info.

What CPUs do they have?  And does the problem really go away when
you boot with idle=mwait ? And what does the following program 
output? 

#include <asm/msr.h>

main()
{
        printf("%x\n", cpuid_edx(5));
}

-Andi
