Return-Path: <linux-kernel-owner+w=401wt.eu-S1755255AbYJLTq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbYJLTq5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 15:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753398AbYJLTqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 15:46:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49227 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371AbYJLTqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 15:46:47 -0400
Date: Sun, 12 Oct 2008 21:46:42 +0200
From: Karel Zak <kzak@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [kerneloops] regression in 2.6.27 wrt "lock_page" and the
	"hwclock" program
Message-ID: <20081012194641.GH10429@nb.net.home>
References: <20081004174433.14a5e093@infradead.org> <20081004215225.2444d54b.akpm@linux-foundation.org> <20081005081145.30ba921b@infradead.org> <20081005102742.de8353b4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081005102742.de8353b4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 05, 2008 at 10:27:42AM -0700, Andrew Morton wrote:
> On Sun, 5 Oct 2008 08:11:45 -0700 Arjan van de Ven <arjan@infradead.org> wrote:
> > 
> > static unsigned long   
> > atomic(const char *name, unsigned long (*op)(unsigned long),
> >        unsigned long arg)
> > {
> >   unsigned long v;
> >   __asm__ volatile ("cli");
> >   v = (*op)(arg);
> >   __asm__ volatile ("sti");
> >   return v;
> > } 
> > 
> > looks like it (but only on 32 bit x86, not on 64 bit x86)
> 
> I suspect this is new in hwclock?

 since util-linux-2.9v, year 1999

> > (and yes someone really ought to fix hwclock; it's rather broken)
> 
> well yeah. Recently broken?

 9 years ago

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
