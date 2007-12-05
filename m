Return-Path: <linux-kernel-owner+w=401wt.eu-S1751922AbXLEAkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922AbXLEAkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 19:40:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750915AbXLEAk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 19:40:29 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45682 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750813AbXLEAk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 19:40:28 -0500
Date: Tue, 4 Dec 2007 16:39:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: lenb@kernel.org, ebiederm@xmission.com, protasnb@gmail.com, ak@suse.de,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386 IOAPIC: de-fang IRQ compression
Message-Id: <20071204163946.63ac73ce.akpm@linux-foundation.org>
In-Reply-To: <20071204122649.GB27286@elte.hu>
References: <200711280121.18376.lenb@kernel.org>
	<20071204122649.GB27286@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Dec 2007 13:26:49 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> * Len Brown <lenb@kernel.org> wrote:
> 
> >     So while the irq compression code on i386 should really
> >     be deleted -- even before merging the x86_64 irq-overhaul,
> >     this patch simply disables it on all high volume systems
> >     to avoid problems #1 and #2 on most all i386 systems.
> >     
> >     A large system with pin numbers >=64 will still have compression
> >     to conserve limited IRQ numbers for sparse IOAPICS.  However,
> >     the vast majority of the planet, those with only pin numbers < 64
> >     will use an identity GSI -> IRQ mapping.
> >     
> >     Signed-off-by: Len Brown <len.brown@intel.com>
> 
> thanks for the patch and the extensive description. I've applied this to 
> x86.git.

Len applied it to his tree too.
