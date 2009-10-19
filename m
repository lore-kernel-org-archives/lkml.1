Return-Path: <linux-kernel-owner+w=401wt.eu-S1756085AbZJSMsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbZJSMsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 08:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbZJSMsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 08:48:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38236 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157AbZJSMsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 08:48:35 -0400
Date: Mon, 19 Oct 2009 14:48:38 +0200
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       Ian Kent <raven@themaw.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 4/6] brlock: introduce special brlocks
Message-ID: <20091019124838.GE27856@wotan.suse.de>
References: <20091015044026.319860788@suse.de> <20091015050048.777261867@suse.de> <20091018222512.683973f7.akpm@linux-foundation.org> <20091019094909.GC27856@wotan.suse.de> <20091019052400.e7f304aa.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091019052400.e7f304aa.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19, 2009 at 05:24:00AM -0700, Andrew Morton wrote:
> On Mon, 19 Oct 2009 11:49:09 +0200 Nick Piggin <npiggin@suse.de> wrote:
> > > generates a definition, not a declaration.  Hence DEFINE_BRLOCK.
> > > 
> > > </petpeeve #29>
> > 
> > Well yes, but being a static inline, then I don't know of a better 
> > way. Probably just better not to pretend we are expanding a simple
> > declaration here, and name it something differently? (BRLOCK_HEADER(blah))?
> 
> DEFINE_BRLOCK(blah)

Well I use DEFINE_BRLOCK for the .c file definitions which include
non-static non-inline functions, so you can't put it in a .h. So
AFAIKS you need both. Athough DECLARE_BRLOCK is not strictly for
declarations because of those static inline functions so I agree the
name is not ideal.

