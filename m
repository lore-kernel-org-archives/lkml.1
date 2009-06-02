Return-Path: <linux-kernel-owner+w=401wt.eu-S1756245AbZFBPXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbZFBPXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 11:23:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755210AbZFBPW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 11:22:58 -0400
Received: from mail-qy0-f104.google.com ([209.85.221.104]:39989 "EHLO
	mail-qy0-f104.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934AbZFBPW5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 11:22:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=Ax4ycTEgBnffQ/fucmZKCjqAENqB5UYDXxDVL0MLIlymFXDCs1wFqN5uAVQBEcQ0CB
         miBRVITclautxmQ3Rl2F2lWXLXAIpQitbL6Tca8Uc6exLSq4W5qZBNDT2Dga+XndKznQ
         unIxquQrqvqP8vyiT5+0hJjh8CgVESfBmcq6s=
MIME-Version: 1.0
In-Reply-To: <20090602150339.GF3914@think>
References: <4A0B62F7.5030802@goop.org> <20090525091527.GA7535@elte.hu>
	 <4A1C3805.7060404@goop.org> <20090528061702.GB6920@wotan.suse.de>
	 <20090530102330.GC16913@elte.hu> <20090602141802.GC3914@think>
	 <a36005b50906020749p22b89693k5c4ae171d18966a7@mail.gmail.com>
	 <20090602150339.GF3914@think>
Date: Tue, 2 Jun 2009 08:22:57 -0700
Message-ID: <a36005b50906020822m33917c6fn5061af562b54c6c2@mail.gmail.com>
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on native 
	kernels
From: Ulrich Drepper <drepper@gmail.com>
To: Chris Mason <chris.mason@oracle.com>, Ulrich Drepper <drepper@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 2, 2009 at 8:03 AM, Chris Mason <chris.mason@oracle.com> wrote:
> The idea that people shipping xen aren't interested in performance
> regressions is really strange to me.

Why?  They have a different base line.  For them any regression to
bare hardware performance is even a positive (since it means the gap
between hardware and virt shrinks).


> Dynamic patching is a big wad of duct tape over the problem.

And what do you call the Xen model?  It's a perfect fit IMO.


> I'm not saying to take harmful code, I'm saying to take code with a
> small performance regression under a specific CONFIG_.  Slub regresses
> more than 1% on database loads, CONFIG_SCHED_GROUPS, the list goes on
> and on.

None of those have to be enabled in default kernels.


> The best place to fix xen is in the kernel.

No.  The best way to fix things is _on the way into the kernel_.
