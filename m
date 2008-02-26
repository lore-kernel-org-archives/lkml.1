Return-Path: <linux-kernel-owner+w=401wt.eu-S1765154AbYBZUdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765154AbYBZUdM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 15:33:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764869AbYBZUco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 15:32:44 -0500
Received: from server54.tchmachines.com ([72.9.244.106]:39496 "EHLO
	server54.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762099AbYBZUcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 15:32:43 -0500
Date: Tue, 26 Feb 2008 12:32:35 -0800
From: Ravikiran Thirumalai <kiran@scalemp.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       shai@scalemp.com
Subject: Re: [PATCH] x86_64: make amd quad core 8 socket system not be clustered_box v2
Message-ID: <20080226203235.GH5914@localdomain>
References: <200802232148.43255.yinghai.lu@sun.com> <20080224122903.GC13637@one.firstfloor.org> <20080225190819.GE3143@localdomain> <86802c440802251405w7025a8b2na5fde4dcbf56067e@mail.gmail.com> <20080226033945.GJ3143@localdomain> <20080226034625.GE21577@one.firstfloor.org> <20080226040541.GK3143@localdomain> <86802c440802252127i36fcd164xe6671aada160766a@mail.gmail.com> <20080226184235.GA5914@localdomain> <86802c440802261100j322ee6a6yef9108dc175de459@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440802261100j322ee6a6yef9108dc175de459@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - server54.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 11:00:58AM -0800, Yinghai Lu wrote:
>
>1. if acpi=off ?

Well that is not a realistic scenario for any multi chassi NUMA machine,
since the proximity information is very important and turning acpi off
deprives the OS of this information.

>2. some system will be treated wrong.
>my four sockets system
>ACPI: SLIT: nodes = 4
> 10 13 13 16
> 13 10 16 13
> 13 16 10 13
> 16 13 13 10
>my eight sockets system

This makes it difficult to use SLIT for multi chassi detection then :(.
Did not know such SLIT tables existed on single board machines.

Thanks,
Kiran
