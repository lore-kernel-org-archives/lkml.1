Return-Path: <linux-kernel-owner+w=401wt.eu-S1758906AbZAWRlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906AbZAWRlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 12:41:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755591AbZAWRkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 12:40:55 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45813 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851AbZAWRky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 12:40:54 -0500
Subject: Re: [PATCH] x86,mm: fix pte_free()
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Hugh Dickins <hugh@veritas.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       L-K <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       David Howells <dhowells@redhat.com>
In-Reply-To: <20090123173421.GA30980@elte.hu>
References: <1232728669.4826.143.camel@laptop>
	 <20090123173421.GA30980@elte.hu>
Content-Type: text/plain
Date: Fri, 23 Jan 2009 18:39:46 +0100
Message-Id: <1232732387.4850.1.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-23 at 18:34 +0100, Ingo Molnar wrote:

> So i agree with the fix, but the patch does not look right: shouldnt that 
> be pgtable_page_dtor(pte), so that we get ->mapping cleared via 
> pte_lock_deinit()? (which i guess your intention was here - this probably 
> wont even build)

Yeah, I somehow fudged it, already send out a better one. -- One of them
days I guess :-(

