Return-Path: <linux-kernel-owner+w=401wt.eu-S1756771AbYG1Ubj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbYG1Ubj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 16:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbYG1Ubb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 16:31:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33486 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751496AbYG1Uba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 16:31:30 -0400
Date: Mon, 28 Jul 2008 13:30:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: righi.andrea@gmail.com
Cc: kosaki.motohiro@jp.fujitsu.com, torvalds@linux-foundation.org,
       linux-mm@kvack.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/1] mm: unify pmd_free() implementation
Message-Id: <20080728133030.8b29fa5a.akpm@linux-foundation.org>
In-Reply-To: <488DFFB0.1090107@gmail.com>
References: <alpine.LFD.1.10.0807280851130.3486@nehalem.linux-foundation.org>
	<488DF119.2000004@gmail.com>
	<20080729012656.566F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<488DFFB0.1090107@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2008 19:19:44 +0200
Andrea Righi <righi.andrea@gmail.com> wrote:

> KOSAKI Motohiro wrote:
> >> yep! clear.
> >>
> >> Ok, in this case wouldn't be better at least to define pud_free() as:
> >>
> >> static inline pud_free(struct mm_struct *mm, pmd_t *pmd)
> >> {
> >> }
> > 
> > I also like this :)
> 
> ok, a simpler patch using the inline function will follow.
> 

I can second that.  See
http://userweb.kernel.org/~akpm/mmotm/broken-out/include-asm-generic-pgtable-nopmdh-macros-are-noxious-reason-435.patch

Ingo cruelly ignored it.  Probably he's used to ignoring the comit
storm which I send in his direction - I'll need to resend it sometime.

I'd consider that patch to be partial - we should demacroize the
surrounding similar functions too.  But that will require a bit more
testing.

