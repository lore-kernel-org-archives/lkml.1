Return-Path: <linux-kernel-owner+w=401wt.eu-S1751965AbZAZDJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbZAZDJ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 22:09:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751173AbZAZDJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 22:09:18 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55022 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbZAZDJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 22:09:18 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86,mm: fix pte_free()
Cc: kosaki.motohiro@jp.fujitsu.com, Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Hugh Dickins <hugh@veritas.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       L-K <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       David Howells <dhowells@redhat.com>
In-Reply-To: <20090123174543.GA16348@elte.hu>
References: <1232732387.4850.1.camel@laptop> <20090123174543.GA16348@elte.hu>
Message-Id: <20090127120636.1BDF.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Mon, 26 Jan 2009 12:09:13 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Fri, 2009-01-23 at 18:34 +0100, Ingo Molnar wrote:
> > 
> > > So i agree with the fix, but the patch does not look right: shouldnt that 
> > > be pgtable_page_dtor(pte), so that we get ->mapping cleared via 
> > > pte_lock_deinit()? (which i guess your intention was here - this probably 
> > > wont even build)
> > 
> > Yeah, I somehow fudged it, already send out a better one. -- One of them
> > days I guess :-(
> 
> no problem - applied to tip/x86/urgent, thanks Peter!

please fix typo. s/nm10300/MN10300/ :)
at first look, I don't understand his intention.



