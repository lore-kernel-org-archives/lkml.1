Return-Path: <linux-kernel-owner+w=401wt.eu-S934478AbYDVOgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934478AbYDVOgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 10:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762944AbYDVOgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 10:36:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36387 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762565AbYDVOgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 10:36:14 -0400
Date: Tue, 22 Apr 2008 11:35:39 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hermann pitton <hermann-pitton@arcor.de>, brandon@ifup.org,
       jasny@vidsoft.de, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: 2.6.25 regression: vivi - scheduling while atomic
Message-ID: <20080422113539.0b3002f9@gaivota>
In-Reply-To: <20080422062938.0e491c0c.akpm@linux-foundation.org>
References: <20080421081639.GE26724@vidsoft.de>
	<20080421223751.GD9073@plankton.ifup.org>
	<1208822912.10519.24.camel@pc10.localdom.local>
	<20080422062938.0e491c0c.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > This happenes on a vanilla 2.6.25 with loaded nvidia graphics module.
> > > > System architecture is x86_64. If it matters I'll try to reproduce this
> > > > error on a non tainted kernel.
> > > 
> > > No need to reproduce on a non-tainted Kernel.  This is a known issue
> > > with patches merged into the v4l-dvb tree several weeks ago but it seems
> > > to not have made it into 2.6.25 :(
> > > 
> > >  http://linuxtv.org/hg/v4l-dvb/rev/06eb92ed0b18
> > >  http://linuxtv.org/hg/v4l-dvb/rev/c50180f4ddfc
> > > 
> > > I can rebase the patches for 2.6.25 but they are too big to go into the
> > > stable 2.6.25 tree...

Unfortunately, the tests for the patches fixing several videobuf issues
finished later on -rc9, when Linus were releasing 2.6.25. 

I should send the videobuf patches to Linus tree, together with other patches,
probably today. After that, I think we should backport the fixes for 2.6.25,
and test it again, with vanilla 2.6.25.

The issue here is that videobuf suffered several changes on this development
cycle. Probably, only a few of those patches are needed to fix the issue. So,
we need to handle this with care, to avoid the risk of damaging other drivers that
relies on videobuf.

Cheers,
Mauro
