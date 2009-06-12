Return-Path: <linux-kernel-owner+w=401wt.eu-S933875AbZFLKcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933875AbZFLKcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 06:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753672AbZFLKcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 06:32:01 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:46676 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbZFLKcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 06:32:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=SwQOzzfa8iIUOjd/aCdB/hOzOihuEcRj7Nk73YR0vkHswYeDLgzK3MsB6O/590cjIR
         kNzT09ew0H/g3jQKCiq15vw3DHSSGgJnNUgY9QCIwG8SpEuXxWCgMQ+bHqTPq/QlRg4r
         hTaATbyynpfGbiovgs/73Asuza/ASywk9aeLQ=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0906121328030.32274@melkki.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0906121113210.29129@melkki.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0906121201490.30049@melkki.cs.Helsinki.FI>
	 <20090612091002.GA32052@elte.hu>
	 <84144f020906120249y20c32d47y5615a32b3c9950df@mail.gmail.com>
	 <20090612100756.GA25185@elte.hu>
	 <84144f020906120311x7c7dd628s82e3ca9a840f9890@mail.gmail.com>
	 <20090612101511.GC13607@wotan.suse.de>
	 <Pine.LNX.4.64.0906121328030.32274@melkki.cs.Helsinki.FI>
Date: Fri, 12 Jun 2009 13:32:01 +0300
X-Google-Sender-Auth: b160025538c699d8
Message-ID: <84144f020906120332q1a09ed14w155719a1107ae373@mail.gmail.com>
Subject: Re: [PATCH v2] slab,slub: ignore __GFP_WAIT if we're booting or 
	suspending
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 1:30 PM, Pekka J Enberg<penberg@cs.helsinki.fi> wrote:
> Hmm. This is turning into one epic patch discussion for sure! But here's a
> patch to do what you suggested. With the amount of patches I am
> generating, I'm bound to hit the right one sooner or later, no?-)

[ And yes, I do see SLAB parts are not even compiling. But you get the idea. ]
