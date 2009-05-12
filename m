Return-Path: <linux-kernel-owner+w=401wt.eu-S1759051AbZELQEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759051AbZELQEn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 12:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754343AbZELQEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 12:04:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44407 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbZELQEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 12:04:33 -0400
Message-ID: <4A099DFC.7040905@zytor.com>
Date: Tue, 12 May 2009 09:04:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Jan Beulich <JBeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: uses of cmpxchg/xadd in spinlock.h and rwsem.h vs. CONFIG_M386
References: <4A09AF8402000078000007DC@vpn.id2.novell.com> <4A099AF0.8020001@zytor.com> <20090512155702.GB31131@wotan.suse.de>
In-Reply-To: <20090512155702.GB31131@wotan.suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> 
> Is it time to get rid of attempts to support SMP kernels that run on 386, then?
> Considering we don't actually support SMP 386, and if there is any 386 systems
> then they're going to be running custom kernels anyway.
> 

Makes sense to me.  We have never supported SMP 386 to the best of my
knowledge, and a patch to rip that out would be appreciated.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

