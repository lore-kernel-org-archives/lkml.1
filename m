Return-Path: <linux-kernel-owner+w=401wt.eu-S1753314AbYCPOds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbYCPOds (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 10:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbYCPOdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 10:33:41 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:50042
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbYCPOdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 10:33:40 -0400
Message-ID: <47DD2FC1.8040106@qumranet.com>
Date: Sun, 16 Mar 2008 16:33:37 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Nick Piggin <npiggin@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org
Subject: Re: [rfc][patch] x86-64 new smp_call_function design
References: <20080227124217.GA1340@wotan.suse.de> <47C55FD2.8030809@suse.de> <20080227130716.GB1340@wotan.suse.de> <47C5668C.6040906@suse.de>
In-Reply-To: <47C5668C.6040906@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>
>>>> As far as I understand, calling a subset of online CPUs that is not all or
>>>> one, is used quite infrequently, so this might be OK.
>>>>         
>>> With cpusets and isolation etc. it is the normal case.
>>>       
>> Oh really? Coming from what callers?
>>     
>
> The isolation work is not merged yet, but it will essentially need
> to turn a lot of the _call_function()s into _call_function_mask()
>   

kvm is also a heavy user of smp_call_function_mask(); if you run 
multiple smp guests you'll see plenty of disjoint smp_call_function_mask()s.

-- 
error compiling committee.c: too many arguments to function

