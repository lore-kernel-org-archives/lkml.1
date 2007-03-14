Return-Path: <linux-kernel-owner+w=401wt.eu-S1752610AbXCNRj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbXCNRj2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 13:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbXCNRj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 13:39:27 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:40612 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbXCNRj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 13:39:27 -0400
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 -
	Take 2
From: Steven Rostedt <rostedt@goodmis.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>
In-Reply-To: <Pine.LNX.4.61.0703141732540.1199@yvahk01.tjqt.qr>
References: <20070314050819.536207642@goodmis.org>
	 <p73slc8863r.fsf@bingen.suse.de> <20070314125330.GA13168@elte.hu>
	 <1173879210.31159.30.camel@localhost.localdomain>
	 <20070314134112.GB13486@elte.hu>
	 <1173883577.31159.50.camel@localhost.localdomain>
	 <Pine.LNX.4.61.0703141732540.1199@yvahk01.tjqt.qr>
Content-Type: text/plain
Date: Wed, 14 Mar 2007 13:39:04 -0400
Message-Id: <1173893944.31159.60.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-14 at 17:33 +0100, Jan Engelhardt wrote:
> On Mar 14 2007 10:46, Steven Rostedt wrote:
> >
> >> symbolic links perhaps? In that case i'd also introduce a common naming 
> >> scheme: x86_early_printk.c - to make sure we know it right away that 
> >> those files are bi-arch.
> >
> >Does the Linux code tree already support sym links? IOW, are there
> >already sym links in the code tree? (/me probably should just look ;)
> 
> /usr/src/linux/include/asm -> /usr/src/linux/include/asm-i386

That's created at build time.  But I don't see anywhere in a freshly
cloned repo or fresh untar of the linux tarball, where there exists any
symbolic links.

-- Steve


