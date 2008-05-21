Return-Path: <linux-kernel-owner+w=401wt.eu-S935845AbYEUQSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935845AbYEUQSY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 12:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760583AbYEUQSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 12:18:09 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51390 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759519AbYEUQSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 12:18:07 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5299"; a="3297899"
Message-ID: <48344B3D.5010404@qualcomm.com>
Date: Wed, 21 May 2008 09:18:05 -0700
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Paul Jackson <pj@sgi.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       menage@google.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: IRQ affinities
References: <47D73086.2030008@qualcomm.com>	<6599ad830803111827n1cb8e2c7i47c2ef3f3bb58995@mail.gmail.com>	<47D7411E.1000009@qualcomm.com>	<6599ad830803111936jd940deam8584bc971c3b6f41@mail.gmail.com>	<47D74595.4080100@qualcomm.com>	<6599ad830803112009y18d9e43ft8e3fc4a551d891da@mail.gmail.com>	<20080311235939.1ebee8e3.pj@sgi.com>	<47D81FE1.6030205@qualcomm.com>	<20080312135746.89456f2a.pj@sgi.com>	<47D82AD2.1070108@qualcomm.com>	<20080312143253.3dd72c7f.pj@sgi.com>	<47D83858.4030806@qualcomm.com>	<20080312153712.bc5df7a1.pj@sgi.com>	<47D8593A.6040503@qualcomm.com>	<20080312183059.6716d630.pj@sgi.com>	<47D87BE5.4010702@qualcomm.com>	<20080313020300.92244956.pj@sgi.com>	<47FE5655.10900@qualcomm.com>	<20080414133902.7878cfce.pj@sgi.com>	<1210329926.13978.224.camel@twins>	<20080509061727.5057de1f.pj@sgi.com>	<48337792.20606@qualcomm.com> <20080520214523.60323aae@infradead.org>
In-Reply-To: <20080520214523.60323aae@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Tue, 20 May 2008 18:14:58 -0700
> Max Krasnyanskiy <maxk@qualcomm.co
> 
>> For the IRQs specifically all I need is to be able to tell the kernel
>> to not route IRQs to certain CPUs. That's mostly works already via 
>> /proc/irq/N/smp_affinity, the problem is dynamically allocated irqs
>> because /proc/irq/N directory does not exist until those IRQs are
>> allocated/enabled.
> \\
> 
> why don't you tell irqbalance instead? it'll make sure the irq stays
> out of the wind...
> 

That will be too late. By the time irqbalance sees that IRQ it may have 
already fired (possibly several times) on the "wrong" processor.

Max

