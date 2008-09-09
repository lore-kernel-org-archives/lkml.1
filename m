Return-Path: <linux-kernel-owner+w=401wt.eu-S1756108AbYIIIPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbYIIIPX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 04:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753743AbYIIIPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 04:15:07 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:18765 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532AbYIIIPG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 04:15:06 -0400
Message-Id: <48C64CC3.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Tue, 09 Sep 2008 09:15:31 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Yinghai Lu" <yhlu.kernel@gmail.com>, <tglx@linutronix.de>,
       <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86: x86_{phys,virt}_bits field also for i386 (v3)
References: <48C13D1C.76E4.0078.0@novell.com>
 <20080905150030.GD10292@elte.hu> <48C51F8D.76E4.0078.0@novell.com>
 <20080908134019.GB11993@elte.hu> <20080908185417.GA17654@elte.hu>
 <48C64524.76E4.0078.0@novell.com> <20080909074727.GA13747@elte.hu>
 <20080909075853.GA27438@elte.hu>
In-Reply-To: <20080909075853.GA27438@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Ingo Molnar <mingo@elte.hu> 09.09.08 09:58 >>>
>
>build failure:
>
>arch/x86/kernel/cpu/common.c: In function 'cpu_detect':
>arch/x86/kernel/cpu/common.c:445: error: 'struct cpuinfo_x86' has no member named 'x86_phys_bits'

Not for me - the original patch made the field common to 32/64-bits, so the
delta patch (with the original one re-enabled [or the revert removed])
should be able to use it. It's also suspicious that you get this only in one
place, while the field is being used several times...

Jan

