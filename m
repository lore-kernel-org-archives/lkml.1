Return-Path: <linux-kernel-owner+w=401wt.eu-S1754941AbYJBVe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941AbYJBVe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 17:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754405AbYJBVev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 17:34:51 -0400
Received: from kroah.org ([198.145.64.141]:49976 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754300AbYJBVeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 17:34:50 -0400
Date: Thu, 2 Oct 2008 14:31:46 -0700
From: Greg KH <greg@kroah.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Veen <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Sven Dietrich <sdietrich@suse.de>
Subject: Re: [RFC patch 0/5] genirq: add infrastructure for threaded
	interrupt handlers
Message-ID: <20081002213146.GA9201@kroah.com>
References: <20081001223213.078984344@linutronix.de> <873ajfoy1a.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <873ajfoy1a.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2008 at 04:46:09PM +0200, Andi Kleen wrote:
> Thomas Gleixner <tglx@linutronix.de> writes:
> >
> >  - move long running handlers out of the hard interrupt context
> 
> I'm not sure I'm really looking forward to this brave new world
> of very long running interrupt handlers. e.g. what do you
> do for example when some handler blocks for a very long time?

We have this issue today with some irqs (USB is known for issue here...)

So I don't think this is a big issue, and in the end, a better idea as
it might force us to confront some of the big abusers and fix them.

thanks,

greg k-h
