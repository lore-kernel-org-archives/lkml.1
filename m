Return-Path: <linux-kernel-owner+w=401wt.eu-S1753400AbXDOTfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbXDOTfo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 15:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753403AbXDOTfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 15:35:44 -0400
Received: from holomorphy.com ([66.93.40.71]:53895 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400AbXDOTfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 15:35:43 -0400
Date: Sun, 15 Apr 2007 12:35:31 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Willy Tarreau <w@1wt.eu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Jiri Slaby <jirislaby@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070415193531.GD2986@holomorphy.com>
References: <20070414132732.GA22103@1wt.eu> <20070414161927.GD3099@elte.hu> <m1abxanahn.fsf@ebiederm.dsl.xmission.com> <20070414172920.GA2433@1wt.eu> <m1647yn956.fsf@ebiederm.dsl.xmission.com> <20070414175433.GA17527@elte.hu> <20070414181854.GA5826@1wt.eu> <20070415175555.GA28524@elte.hu> <20070415180604.GA550@1wt.eu> <20070415192046.GA7504@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070415192046.GA7504@elte.hu>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2007 at 09:20:46PM +0200, Ingo Molnar wrote:
> so Linus was right: this was caused by scheduler starvation. I can see 
> one immediate problem already: the 'nice offset' is not divided by 
> nr_running as it should. The patch below should fix this but i have yet 
> to test it accurately, this change might as well render nice levels 
> unacceptably ineffective under high loads.

I've been suggesting testing CPU bandwidth allocation as influenced by
nice numbers for a while now for a reason.


-- wli
