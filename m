Return-Path: <linux-kernel-owner+w=401wt.eu-S1761296AbYEUEpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761296AbYEUEpv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 00:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750983AbYEUEpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 00:45:43 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37225 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbYEUEpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 00:45:42 -0400
Date: Tue, 20 May 2008 21:45:23 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Max Krasnyanskiy <maxk@qualcomm.com>
Cc: Paul Jackson <pj@sgi.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       menage@google.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: IRQ affinities
Message-ID: <20080520214523.60323aae@infradead.org>
In-Reply-To: <48337792.20606@qualcomm.com>
References: <47D73086.2030008@qualcomm.com>
	<6599ad830803111827n1cb8e2c7i47c2ef3f3bb58995@mail.gmail.com>
	<47D7411E.1000009@qualcomm.com>
	<6599ad830803111936jd940deam8584bc971c3b6f41@mail.gmail.com>
	<47D74595.4080100@qualcomm.com>
	<6599ad830803112009y18d9e43ft8e3fc4a551d891da@mail.gmail.com>
	<20080311235939.1ebee8e3.pj@sgi.com>
	<47D81FE1.6030205@qualcomm.com>
	<20080312135746.89456f2a.pj@sgi.com>
	<47D82AD2.1070108@qualcomm.com>
	<20080312143253.3dd72c7f.pj@sgi.com>
	<47D83858.4030806@qualcomm.com>
	<20080312153712.bc5df7a1.pj@sgi.com>
	<47D8593A.6040503@qualcomm.com>
	<20080312183059.6716d630.pj@sgi.com>
	<47D87BE5.4010702@qualcomm.com>
	<20080313020300.92244956.pj@sgi.com>
	<47FE5655.10900@qualcomm.com>
	<20080414133902.7878cfce.pj@sgi.com>
	<1210329926.13978.224.camel@twins>
	<20080509061727.5057de1f.pj@sgi.com>
	<48337792.20606@qualcomm.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2008 18:14:58 -0700
Max Krasnyanskiy <maxk@qualcomm.co
> 

> For the IRQs specifically all I need is to be able to tell the kernel
> to not route IRQs to certain CPUs. That's mostly works already via 
> /proc/irq/N/smp_affinity, the problem is dynamically allocated irqs
> because /proc/irq/N directory does not exist until those IRQs are
> allocated/enabled.
\\

why don't you tell irqbalance instead? it'll make sure the irq stays
out of the wind...
