Return-Path: <linux-kernel-owner+w=401wt.eu-S1765964AbXHHNYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765964AbXHHNYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 09:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759435AbXHHNYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 09:24:24 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:54395 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759392AbXHHNYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 09:24:23 -0400
Date: Wed, 8 Aug 2007 09:23:25 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andi Kleen <andi@firstfloor.org>
cc: Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, mingo@elte.hu, chrisw@sous-sol.org,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org
Subject: Re: [PATCH 18/25] [PATCH] turn priviled operations into macros in
 entry.S
In-Reply-To: <p738x8mrv4m.fsf@bingen.suse.de>
Message-ID: <Pine.LNX.4.58.0708080919330.7236@gandalf.stny.rr.com>
References: <11865467522495-git-send-email-gcosta@redhat.com>
 <200708081138.23018.ak@suse.de> <Pine.LNX.4.58.0708080740490.5921@gandalf.stny.rr.com>
 <200708081424.49896.ak@suse.de> <Pine.LNX.4.58.0708080835350.6751@gandalf.stny.rr.com>
 <p738x8mrv4m.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--
On Wed, 8 Aug 2007, Andi Kleen wrote:

> Steven Rostedt <rostedt@goodmis.org> writes:
>
> > On Wed, 8 Aug 2007, Andi Kleen wrote:
> >
> > >
> > > > Probably not, but this part of the code I don't fully understand.
> > >
> > > I would suggest to defer all this until at least one example to test it
> > > (except vsmp which is too simple) is around.
> >
> > Who uses that code? NMIs and debug regs?  Lguest only has the host handle
> > the NMIs (doesn't pass to guest). And we haven't gotten to debug regs. Who
> > else uses that part of the code?
>
> I'm not sure I understand your question. You're asking who uses entry.S?
> Answer would be everybody. If you asked something else please reformulate.

When I said "this part of the code I don't fully understand" I was not
talking about entry.S.  I understand entry.S very well, but the comment
was originally on the paranoid_restore code. Which I thought had to deal
with NMIs and such that I didn't worry about that I simply did the
default.

>>  paranoid_restore\trace:
>>       RESTORE_ALL 8
>> -     iretq
>> +     INTERRUPT_RETURN
>
>I suspect Xen will need much more changes anyways because of its
>ring 3 guest. Are these changes sufficient for lguest?


The above was what I was replying to.

-- Steve

