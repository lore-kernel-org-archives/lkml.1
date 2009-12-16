Return-Path: <linux-kernel-owner+w=401wt.eu-S935360AbZLPTUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935360AbZLPTUQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 14:20:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935336AbZLPTT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 14:19:58 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42899 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763136AbZLPTTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 14:19:55 -0500
Subject: Re: perf and libdwarf on debian
From: Peter Zijlstra <peterz@infradead.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <4B292F69.3000608@redhat.com>
References: <20091216135448.GD11618@aftab>
	 <1260988340.21028.198.camel@laptop>  <4B292F69.3000608@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Dec 2009 20:19:15 +0100
Message-ID: <1260991155.21028.261.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-16 at 14:05 -0500, Masami Hiramatsu wrote:

> > and simply add -I/usr/include/libdwarf to CPPFLAGS or something like
> > that.
> 
> Ah, right, I was stupid!
> 
> Masami Hiramatsu wrote:
> > e.g.
> > 
> > ifeq ($(shell sh -c "(test -d /usr/include/libdwarf/ && echo y)", y)
> > 	BASIC_CFLAGS += -I /usr/include/libdwarf 
> > endif
> 
> So, it just need;
> 
> BASIC_CFLAGS += -I/usr/include/libdwarf 
> 
> And including just libdwarf.h and dwarf.h.

Well, I'm not 100% sure -I/foo will actually work if foo doesn't exist,
but I'd sure try it first since its less typing :-)

If it doesn't your suggestion is a good alternative.

