Return-Path: <linux-kernel-owner+w=401wt.eu-S1756260AbYGNRZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260AbYGNRZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 13:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754062AbYGNRZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 13:25:42 -0400
Received: from www.tglx.de ([62.245.132.106]:44706 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803AbYGNRZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 13:25:41 -0400
Date: Mon, 14 Jul 2008 19:24:26 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT pull] genirq updates for 2.6.27
In-Reply-To: <20080714101722.e0df1608.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0807141923500.3283@apollo.tec.linutronix.de>
References: <alpine.LFD.1.10.0807141822470.3283@apollo.tec.linutronix.de> <20080714101722.e0df1608.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008, Andrew Morton wrote:
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git genirq
> > 
> 
> Could you cc me on the pull requests please?  I _do_ look them over,
> but I'm often days behind in my lkml reading.

Sorry, forgot it.
 
> > +void register_default_affinity_proc(void)
> > +{
> > +#ifdef CONFIG_SMP
> > +	struct proc_dir_entry *entry;
> > +
> > +	/* create /proc/irq/default_smp_affinity */
> > +	entry = create_proc_entry("default_smp_affinity", 0600, root_irq_dir);
> > +	if (entry) {
> > +		entry->data = NULL;
> > +		entry->read_proc  = default_affinity_read;
> > +		entry->write_proc = default_affinity_write;
> > +	}
> > +#endif
> > +}
> 
> This should have static scope.

Hmpf, right.

