Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbXLaQfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbXLaQfA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 11:35:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751152AbXLaQex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 11:34:53 -0500
Received: from one.firstfloor.org ([213.235.205.2]:55748 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbXLaQew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 11:34:52 -0500
Date: Mon, 31 Dec 2007 17:36:35 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Andi Kleen <andi@firstfloor.org>, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: asm-x86/msr.h for sanitized headers: clean it or punt it
Message-ID: <20071231163635.GA15298@one.firstfloor.org>
References: <200712310045.24069.vapier@gentoo.org> <p73sl1jyrqx.fsf@bingen.suse.de> <200712311033.34489.vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712311033.34489.vapier@gentoo.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> can you enumerate which functions need to actually go to userspace then ?  the 
rdtscl/rdtscll/rdpmc primarily

> __KERNEL__ markings are a crapshoot at the moment.  you must also be jumping 
> through hoops in order to use the header in the first place since the vanilla 
> one wont compile out of the box.

At least the 64bit one or older 32bit one works without hoops. Agreed that the 
paravirt changes destroyed it on newer 32bit though. That's an unfortunate
regression.

-Andi

