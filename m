Return-Path: <linux-kernel-owner+w=401wt.eu-S1762326AbXHHM6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762326AbXHHM6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 08:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755686AbXHHM6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 08:58:22 -0400
Received: from ns.suse.de ([195.135.220.2]:60205 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512AbXHHM6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 08:58:22 -0400
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, mingo@elte.hu, chrisw@sous-sol.org,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org
Subject: Re: [PATCH 18/25] [PATCH] turn priviled operations into macros in entry.S
References: <11865467522495-git-send-email-gcosta@redhat.com>
	<200708081138.23018.ak@suse.de>
	<Pine.LNX.4.58.0708080740490.5921@gandalf.stny.rr.com>
	<200708081424.49896.ak@suse.de>
	<Pine.LNX.4.58.0708080835350.6751@gandalf.stny.rr.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 08 Aug 2007 15:52:41 +0200
In-Reply-To: <Pine.LNX.4.58.0708080835350.6751@gandalf.stny.rr.com>
Message-ID: <p738x8mrv4m.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

> On Wed, 8 Aug 2007, Andi Kleen wrote:
> 
> >
> > > Probably not, but this part of the code I don't fully understand.
> >
> > I would suggest to defer all this until at least one example to test it
> > (except vsmp which is too simple) is around.
> 
> Who uses that code? NMIs and debug regs?  Lguest only has the host handle
> the NMIs (doesn't pass to guest). And we haven't gotten to debug regs. Who
> else uses that part of the code?

I'm not sure I understand your question. You're asking who uses entry.S? 
Answer would be everybody. If you asked something else please reformulate.

-Andi
