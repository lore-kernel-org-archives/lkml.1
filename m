Return-Path: <linux-kernel-owner+w=401wt.eu-S933207AbXAYEch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933207AbXAYEch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 23:32:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933206AbXAYEch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 23:32:37 -0500
Received: from smtp.osdl.org ([65.172.181.24]:46294 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933207AbXAYEcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 23:32:36 -0500
Date: Wed, 24 Jan 2007 20:31:26 -0800
From: Andrew Morton <akpm@osdl.org>
To: Blaisorblade <blaisorblade@yahoo.it>
Cc: Johannes Stezenbach <js@linuxtv.org>,
       user-mode-linux-devel@lists.sourceforge.net,
       Jeff Dike <jdike@karaya.com>, linux-kernel@vger.kernel.org
Subject: Re: [uml-devel] [PATCH] [UML] fix mknod
Message-Id: <20070124203126.36e78674.akpm@osdl.org>
In-Reply-To: <200701232333.29655.blaisorblade@yahoo.it>
References: <20070122201317.GA8594@linuxtv.org>
	<200701230902.30715.blaisorblade@yahoo.it>
	<20070123131730.GA9286@linuxtv.org>
	<200701232333.29655.blaisorblade@yahoo.it>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jan 2007 23:33:29 +0100
Blaisorblade <blaisorblade@yahoo.it> wrote:

> On Tuesday 23 January 2007 14:17, Johannes Stezenbach wrote:
> > On Tue, Jan 23, 2007 at 09:02:30AM +0100, Blaisorblade wrote:
> > > On Monday 22 January 2007 21:13, Johannes Stezenbach wrote:
> > > > I was playing with user-mode Linux and found that mknod creates
> > > > devices node in hostfs with wrong major/minor numbers.
> > > > The patch below fixes it for me.
> > >
> > > Hmpf. Still having this bug on hostfs is quite bad. Thanks for reporting.
> 
> I've now seen - we never fixed this one, we fixed the analogous problem 
> on 'ls' output and friends (in init_inode, which is used in many places).
> 
> > > It should be hostfs_user.c to take major and minor and to combine them
> > > correctly - it can use libc's macros.
> >
> > Right, below is a better patch.
> 
> Exactly what I meant, thanks!
> I'd say:
> Acked-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
> This can go to 2.6.20, and possibly even to -stable (after either me or Jeff 
> tests it once).

So..  did you test it?
