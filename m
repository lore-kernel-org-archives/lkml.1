Return-Path: <linux-kernel-owner+w=401wt.eu-S1758623AbYBYTIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758623AbYBYTIg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 14:08:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755050AbYBYTI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 14:08:26 -0500
Received: from server54.tchmachines.com ([72.9.244.106]:54404 "EHLO
	server54.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012AbYBYTI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 14:08:26 -0500
Date: Mon, 25 Feb 2008 11:08:19 -0800
From: Ravikiran Thirumalai <kiran@scalemp.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Yinghai Lu <Yinghai.Lu@Sun.COM>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       shai@scalemp.com
Subject: Re: [PATCH] x86_64: make amd quad core 8 socket system not be clustered_box v2
Message-ID: <20080225190819.GE3143@localdomain>
References: <200802210258.45011.yinghai.lu@sun.com> <200802221102.31019.yinghai.lu@sun.com> <47BF1BD9.4020808@firstfloor.org> <200802232148.43255.yinghai.lu@sun.com> <20080224122903.GC13637@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080224122903.GC13637@one.firstfloor.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - server54.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2008 at 01:29:03PM +0100, Andi Kleen wrote:
>On Sat, Feb 23, 2008 at 09:48:42PM -0800, Yinghai Lu wrote:
>> 
>> quad core 8 socket system will have apic id lifting.the apic id range could
>> be [4, 0x23]. and apic_is_clustered_box will think that need to three clusters
>> and that is large than 2. So it is treated as clustered_box.
>
>Ok I see you chose the quick hack over doing it properly ...
>
>> 
>> and will get
>> 
>> Marking TSC unstable due to TSCs unsynchronized
>> 
>> even the CPUs have X86_FEATURE_CONSTANT_TSC set.
>
>I doubt that will do the right thing on AMD based vSMP,
>which also required the cluster check on AMD iirc.
>

Andi, Yes.  AMD based vSMPowered systems uses clustered APICs, and this
check base on cpu vendor id is not good :(.

Thanks,
Kiran
