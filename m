Return-Path: <linux-kernel-owner+w=401wt.eu-S1761485AbYHEQ3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761485AbYHEQ3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 12:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756357AbYHEQ30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 12:29:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756218AbYHEQ3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 12:29:25 -0400
Date: Tue, 5 Aug 2008 09:26:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Adrian Bunk <bunk@kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, v4l-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com, Ralf Baechle <ralf@linux-mips.org>,
       linux-mips@linux-mips.org
Subject: Re: v4l/mips build problem
Message-Id: <20080805092650.af88364a.akpm@linux-foundation.org>
In-Reply-To: <20080806020647.2cf11a2b.sfr@canb.auug.org.au>
References: <20080806012357.55625daf.sfr@canb.auug.org.au>
	<20080805154122.GC22895@cs181140183.pp.htv.fi>
	<20080806020647.2cf11a2b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Aug 2008 02:06:47 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> On Tue, 5 Aug 2008 18:41:22 +0300 Adrian Bunk <bunk@kernel.org> wrote:
> >
> > On Wed, Aug 06, 2008 at 01:23:57AM +1000, Stephen Rothwell wrote:
> > > Hi all,
> > > 
> > > Linus' current tree gets the following error during a mips allmodconfig
> > > build:
> > > 
> > > drivers/media/video/vino.c:4364: error: implicit declaration of function `video_usercopy'
> > 
> > Andrew fixed it with drivers-media-video-vinoc-needs-v4l2-ioctlh.patch 
> > in -mm.
> 
> Maybe we should send that one Linusward ...
> 

yup, I'll send it in unless it turned up in today's linux-next.
