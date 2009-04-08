Return-Path: <linux-kernel-owner+w=401wt.eu-S932428AbZDHViW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428AbZDHViW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 17:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756810AbZDHViL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 17:38:11 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:38914 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757818AbZDHViK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 17:38:10 -0400
Date: Wed, 8 Apr 2009 23:40:14 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Howells <dhowells@redhat.com>
Cc: jeremy@goop.org, mingo@elte.hu, akpm@linux-foundation.org, x86@kernel.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       nickpiggin@yahoo.com.au, tglx@linutronix.de, ysato@users.sourceforge.jp
Subject: Re: [PATCH] FRV: Use <asm-generic/pgtable.h> in NOMMU mode
Message-ID: <20090408214014.GA10366@uranus.ravnborg.org>
References: <20090408205610.GA9970@uranus.ravnborg.org> <20090408184455.GB332@uranus.ravnborg.org> <21081.1239214221@redhat.com> <20090408183011.24150.43310.stgit@warthog.procyon.org.uk> <24317.1239216477@redhat.com> <26753.1239225955@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26753.1239225955@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 10:25:55PM +0100, David Howells wrote:
> Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > > > Any change we can have these header files moved before too
> > > > many patches are queued?
> > > 
> > > Sure.  Do you have patches to move FRV and MN10300 headers?
> > 
> > For frv it is as simple as:
> > 
> > mkdir -p arch/frv/include/asm
> > git mv include/asm-frv/* arch/frv/include/asm
> > git commit
> 
> The thing I really detest about doing this is this:
> 
> 	warthog>git-log -M arch/frv/include/asm/pgtable.h | cat
> 	commit 2203e07b4ba1d1113ab80e7c51062f6994a62d3a
> 	Author: David Howells <dhowells@redhat.com>
> 	Date:   Wed Apr 8 22:20:14 2009 +0100
> 
> 	    FRV: Move to arch/frv/include/asm/
> 
> 	    Move from include/asm-frv/ to arch/frv/include/asm/.
> 
> 	    Signed-off-by: David Howells <dhowells@redhat.com>
> 	warthog>
> 
> So much for the old history:
> 
> 	warthog>git-log include/asm-frv/pgtable.h | grep ^commit | wc -l
> 	20
> 	warthog>

--follow is needed to follow renames when doing git log.

It is not that the history is lost - but hidden a bit.

	Sam
