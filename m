Return-Path: <linux-kernel-owner+w=401wt.eu-S1760352AbYEGEmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760352AbYEGEmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 00:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753447AbYEGEm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 00:42:28 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35878 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbYEGEm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 00:42:27 -0400
Date: Tue, 6 May 2008 21:41:58 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, tony@bakeyournoodle.com,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org
Subject: Re: [PATCH] Silence 'ignoring return value' warnings in
 drivers/video/aty/radeon_base.c
Message-ID: <20080506214158.0f850cda@infradead.org>
In-Reply-To: <20080506212643.444b96db.akpm@linux-foundation.org>
References: <20080424043400.GS20457@bakeyournoodle.com>
	<20080506143936.6357e578.akpm@linux-foundation.org>
	<20080506.144301.233784820.davem@davemloft.net>
	<20080506145608.565b61bf.akpm@linux-foundation.org>
	<20080506210055.75e2f881@infradead.org>
	<20080506211233.f050fd41.akpm@linux-foundation.org>
	<20080506211552.6af7cecc@infradead.org>
	<20080506212314.695daf98.akpm@linux-foundation.org>
	<20080506212643.444b96db.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008 21:26:43 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 6 May 2008 21:23:14 -0700 Andrew Morton
> <akpm@linux-foundation.org> wrote:
> 
> > otcompletelyoh, perhaps we could generate a backtrace from within
> > printk() itself for when it sees messages which have KERN_ERR or
> > some other suitably-chosen (and probably configurable) facility
> > level.
> 
> and if that is impractical, perhaps create a new printk facility
> (KERN_TRACE?) which gets rewritten to KERN_ERR, but tells printk()
> to generate a trace.
> 
> Do we really need the file-n-line info?

for me, it really does help to have that; it saves me and others time
to grep where exactly it happens. it also allows me to tie things to
gitweb automatically
(see  http://www.kerneloops.org/search.php?search=write_msg for an
example of how this works; this feature is very appreciated by several
developers and was done on their request)
