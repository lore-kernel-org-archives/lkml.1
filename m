Return-Path: <linux-kernel-owner+w=401wt.eu-S939387AbXHIMc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939387AbXHIMc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 08:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939346AbXHIMcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 08:32:04 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:41267 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938377AbXHIMcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 08:32:01 -0400
Date: Thu, 9 Aug 2007 08:30:34 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Glauber de Oliveira Costa <glommer@gmail.com>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, mingo@elte.hu, chrisw@sous-sol.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org
Subject: Re: [PATCH 25/25] [PATCH] add paravirtualization support for x86_64
In-Reply-To: <46BABE72.90107@goop.org>
Message-ID: <Pine.LNX.4.58.0708090823140.29847@gandalf.stny.rr.com>
References: <11865467522495-git-send-email-gcosta@redhat.com> 
 <11865468321629-git-send-email-gcosta@redhat.com> 
 <11865468362401-git-send-email-gcosta@redhat.com> 
 <11865468394005-git-send-email-gcosta@redhat.com> 
 <11865468431616-git-send-email-gcosta@redhat.com> 
 <1186546847263-git-send-email-gcosta@redhat.com> 
 <11865468513077-git-send-email-gcosta@redhat.com>  <46BAB5C8.5090906@goop.org>
  <5d6222a80708090002y7fdc6f2dw1dbacd3d27a86433@mail.gmail.com> 
 <46BABC0F.5070002@goop.org> <5d6222a80708090007h3d185ecdm3ea8fa0b5ee96050@mail.gmail.com>
 <46BABE72.90107@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--
On Thu, 9 Aug 2007, Jeremy Fitzhardinge wrote:

> Glauber de Oliveira Costa wrote:
> > On 8/9/07, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> >
> >>> Does it really matter?
> >>>
> >>>
> >> Well, yes, if alignment is an issue.
> >>
> > Of course, But the question rises from the context that they are both
> > together at the beginning. So they are not making anybody non-aligned.
> > Then the question: Why would putting it in the end be different to
> > putting them _together_, aligned at the beginning ?
> >
>
> Well, the point is that if you add new ones then alignment may be an
> issue.  Putting them at the end (with a comment explaining why they're
> there) will make it more robust.  Though splitting them into their own
> sub-structure would probably be better.

Glauber,

I was thinking of putting them at the end too, and that would make it all
work better. But I didn't mention it because I was in the mindset of "well
i386 has that there, we should too" :-(

>
> Hm.  So x86-64 doesn't make 64-bit pointers be 64-bit aligned?

yeah, it usually does. But it's one of those paranoid things, where you
want it to still work even if someone later on throws an
__attribute__((packed)) in on paravirt ops ;-)

-- Steve

