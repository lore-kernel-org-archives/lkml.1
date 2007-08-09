Return-Path: <linux-kernel-owner+w=401wt.eu-S939812AbXHIOi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939812AbXHIOi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 10:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936284AbXHIOiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 10:38:50 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:39585 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934912AbXHIOit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 10:38:49 -0400
Date: Thu, 9 Aug 2007 10:37:21 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andi Kleen <ak@suse.de>
cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, mingo@elte.hu, chrisw@sous-sol.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org
Subject: Re: [PATCH 25/25] [PATCH] add paravirtualization support for x86_64
In-Reply-To: <200708091626.09316.ak@suse.de>
Message-ID: <Pine.LNX.4.58.0708091032300.32067@gandalf.stny.rr.com>
References: <11865467522495-git-send-email-gcosta@redhat.com>
 <200708081200.13669.ak@suse.de> <46BAB9DD.5030400@goop.org>
 <200708091626.09316.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--
On Thu, 9 Aug 2007, Andi Kleen wrote:
>
> > This has to match the normal C calling convention though, doesn't it?
>
> Native cli/sti/save/restore_flags are all only assembly and can be easily
> (in fact more easily than in C) written as pure assembler functions. Then
> you can use whatever calling convention you want.

I agree.
Should we make a paravirt_ops_asm.S file that can implement these native
funcions, and so we can get rid of the C functions only doing asm?

>
> While some paravirt implementations may have more complicated implementations
> i guess it's still a reasonable requirement to make them simple enough
> in pure assembler. If not they can use a trampoline, but that's hopefully
> not needed.

It works for lguest64.  I'm sure it should be no problem with other HVs.

-- Steve

