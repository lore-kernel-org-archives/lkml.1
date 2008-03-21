Return-Path: <linux-kernel-owner+w=401wt.eu-S1761581AbYCUVW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761581AbYCUVW5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 17:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757343AbYCUVWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 17:22:49 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:32957 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381AbYCUVWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 17:22:48 -0400
Date: Fri, 21 Mar 2008 22:22:47 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Ingo Molnar <mingo@elte.hu>
cc: yhlu.kernel@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: early memtest to find bad ram
In-Reply-To: <20080321120313.GD25225@elte.hu>
Message-ID: <alpine.LNX.1.00.0803212221390.10642@fbirervta.pbzchgretzou.qr>
References: <200803202358.33722.yhlu.kernel@gmail.com> <20080321120313.GD25225@elte.hu>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 21 2008 13:03, Ingo Molnar wrote:
> * Yinghai Lu <yhlu.kernel.send@gmail.com> wrote:
>
>> do simple memtest after init_memory_mapping
>> use find_e820_area_size to find all ram range that is not reserved.
>> and do some simple bits test to find some bad ram.
>> if find some bad ram, use reserve_early to exclude that range.
>
> very nice patch! I always thought that this was the proper way to do
> memtest - and we could in fact also do something like this after SMP
> bringup, and hit the memory bus via multiple CPUs. [that will need a
> different enumeration though than e820 maps]

Perhaps this can even be used to provide on-the-fly badram
patch semantics?
