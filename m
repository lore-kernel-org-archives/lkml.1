Return-Path: <linux-kernel-owner+w=401wt.eu-S1763553AbXESIWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763553AbXESIWk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 04:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754084AbXESIWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 04:22:34 -0400
Received: from dedi.luli.de ([88.198.62.74]:53001 "EHLO dedi.luli.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403AbXESIWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 04:22:33 -0400
Message-ID: <464EB3C6.5000402@rootdir.de>
Date: Sat, 19 May 2007 10:22:30 +0200
From: Claas Langbehn <claas@rootdir.de>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Andi Kleen <ak@suse.de>, hpa@zytor.com
Subject: Re: 2.6.22-rc1 does not boot on VIA C3_2 cause of X86_CMPXCHG64 II
References: <464B9D2C.7040704@cv-sv.de> <20070517004209.GE16810@redhat.com> <200705190753.16570.ak@suse.de>
In-Reply-To: <200705190753.16570.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andi!
> Can someone please test if this patch works? 
>   
it applies cleanly to 2.6.22-rc1-mm1

Could you make it also enable C7 CMPXCHG8 (cx8)?
This is because I am getting this error (as written in a diffent posting
on this mailinglist)
 > This kernel requires the following features not present on the CPU...
 > 0:8

Is verify_cpu.S being executed before or after cpucheck.c?



claas
