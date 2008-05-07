Return-Path: <linux-kernel-owner+w=401wt.eu-S1765943AbYEGWJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765943AbYEGWJg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 18:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757140AbYEGWJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 18:09:19 -0400
Received: from www.tglx.de ([62.245.132.106]:34496 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753273AbYEGWJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 18:09:15 -0400
Date: Thu, 8 May 2008 00:08:23 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Adrian Bunk <bunk@kernel.org>
cc: Rene Herman <rene.herman@keyaccess.nl>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, hpa@zytor.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Pavel Machek <pavel@suse.cz>
Subject: Re: 2.6.26, PAT and AMD family 6
In-Reply-To: <20080507214646.GC14951@cs181133002.pp.htv.fi>
Message-ID: <alpine.LFD.1.10.0805072354450.3318@apollo.tec.linutronix.de>
References: <48210A71.1060409@keyaccess.nl> <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com> <20080507124650.GD29935@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de> <48221AE3.6020602@keyaccess.nl>
 <alpine.LFD.1.10.0805072315360.3318@apollo.tec.linutronix.de> <20080507214646.GC14951@cs181133002.pp.htv.fi>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2008, Adrian Bunk wrote:
> > 
> > Yinghai missed to add it to the other place and he is hardly to blame
> > for that. This code is messy and thats not his fault. It will be
> > cleaned up, but that's not an simple taks to do. If you think you can
> > do it without breaking tons of systems, you're welcome.
> 
> It actually is completely his fault.

No it is not. 

1) this code is messy to begin with

2) we accepted the change as is
 
> His commit ***added*** the three copies of the same code.

And you are not able to ******look******* over the brim of your tea
cup and accept that one of them is 64 bit and the others are a tribute
to the not yet distangled shit. There would have been a cleaner and
better way to solve this, but there is always a better and cleaner way
to do things.

Why dont you send a cleanup patch which fixes the three copies problem
instead of spending your time with writing up ivory tower pieces of
wisdom ?

Thanks,

	tglx
