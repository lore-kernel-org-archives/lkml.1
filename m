Return-Path: <linux-kernel-owner+w=401wt.eu-S1756430AbZE3Hhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430AbZE3Hhw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 03:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750939AbZE3Hhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 03:37:45 -0400
Received: from oblivion.subreption.com ([66.240.236.22]:35553 "EHLO
	mail.subreption.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbZE3Hhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 03:37:45 -0400
Date: Sat, 30 May 2009 00:35:28 -0700
From: "Larry H." <research@subreption.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Larry H." <research@subreption.com>, peterz@infradead.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       linux-mm@kvack.org, mingo@redhat.com, pageexec@freemail.hu
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page
	allocator
Message-ID: <20090530073528.GK29711@oblivion.subreption.com>
References: <20090520183045.GB10547@oblivion.subreption.com> <1242852158.6582.231.camel@laptop> <20090520212413.GF10756@oblivion.subreption.com> <20090529155859.2cf20823.akpm@linux-foundation.org> <84144f020905300012h6ca92605ve8fdcbaba39ac054@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020905300012h6ca92605ve8fdcbaba39ac054@mail.gmail.com>
Organization: Subreption LLC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:12 Sat 30 May     , Pekka Enberg wrote:
> Hi Andrew,
> 
> On Sat, May 30, 2009 at 1:58 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > ?But how to do that? ?Particular callsites don't get to alter
> > ?kfree()'s behaviour. ?So they'd need to use a new kfree_sensitive().
> > ?Which is just syntactic sugar around the code whihc we presently
> > ?implement.
> 
> Unless I am missing something here, we already have kfree_sensitive(),
> we just call it kzfree().

You should test that. The results might be surprising, though.

	Larry

