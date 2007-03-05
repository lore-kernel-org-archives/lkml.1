Return-Path: <linux-kernel-owner+w=401wt.eu-S965558AbXCENdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965558AbXCENdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 08:33:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965676AbXCENdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 08:33:15 -0500
Received: from ozlabs.org ([203.10.76.45]:41794 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965558AbXCENdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 08:33:14 -0500
Subject: Re: [patch] paravirt: VDSO page is essential
From: Rusty Russell <rusty@rustcorp.com.au>
To: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       Andi Kleen <ak@suse.de>
In-Reply-To: <45EC1472.3070208@qumranet.com>
References: <20070305120631.GA14105@elte.hu> <45EC0EB7.7080300@qumranet.com>
	 <20070305124024.GA19338@elte.hu>  <45EC1472.3070208@qumranet.com>
Content-Type: text/plain
Date: Tue, 06 Mar 2007 00:32:14 +1100
Message-Id: <1173101534.26165.44.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-05 at 15:00 +0200, Avi Kivity wrote:
> Ingo Molnar wrote:
> > * Avi Kivity <avi@qumranet.com> wrote:
> > but yes, i agree that the hypervisor should have the ability to patch 
> > the syscall instruction of both the hypervisor interface and of the VDSO 
> > interface. But this wasnt implemented like that, and the #ifdef quirk 
> > just /prevents/ a sane solution like that from ever getting done the 
> > right way.
> >   
> 
> Rusty, shouldn't this be a one-liner?  No need to involve the hypervisor 
> here; the guest can s/syscall/int 80/ on its vdso page like it patches 
> cli and its ilk.

Probably, but this is a red herring: see previous reply.  Andi was a
little overzealous w/ CONFIG_PARAVIRT & COMPAT_VDSO, that's all.

I've never thought of replacing the syscall insn.  I'll see if I can
come up with a good reason to want to 8)

Rusty.

