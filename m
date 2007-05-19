Return-Path: <linux-kernel-owner+w=401wt.eu-S1763940AbXESSKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763940AbXESSKk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 14:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756750AbXESSKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 14:10:33 -0400
Received: from terminus.zytor.com ([192.83.249.54]:58428 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016AbXESSKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 14:10:33 -0400
Message-ID: <464F3D8E.8090806@zytor.com>
Date: Sat, 19 May 2007 11:10:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Claas Langbehn <claas@rootdir.de>
CC: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>
Subject: Re: 2.6.22-rc1 does not boot on VIA C3_2 cause of X86_CMPXCHG64 II
References: <464B9D2C.7040704@cv-sv.de> <20070517004209.GE16810@redhat.com> <200705190753.16570.ak@suse.de> <464EB3C6.5000402@rootdir.de>
In-Reply-To: <464EB3C6.5000402@rootdir.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Claas Langbehn wrote:
> Hello Andi!
>> Can someone please test if this patch works?   
> it applies cleanly to 2.6.22-rc1-mm1
> 
> Could you make it also enable C7 CMPXCHG8 (cx8)?
> This is because I am getting this error (as written in a diffent posting
> on this mailinglist)
>> This kernel requires the following features not present on the CPU...
>> 0:8
> 
> Is verify_cpu.S being executed before or after cpucheck.c?

Neither (on i386.)  cpucheck.c *replaces* verify_cpu.S.

On x86-64, verify_cpu.S is still run after in some circumstances,
because it's going to be harder to extricate some of the uses of
verify_cpu.S.  It's still the intention, however.

	-hpa
