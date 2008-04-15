Return-Path: <linux-kernel-owner+w=401wt.eu-S1765032AbYDOUMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765032AbYDOUMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 16:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755540AbYDOUMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 16:12:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50311 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753832AbYDOUMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 16:12:22 -0400
Date: Tue, 15 Apr 2008 13:11:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: hch@infradead.org, alan@lxorguk.ukuu.org.uk, dwmw2@infradead.org,
       miklos@szeredi.hu, me@bobcopeland.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
Message-Id: <20080415131120.f1bab12a.akpm@linux-foundation.org>
In-Reply-To: <20080415192432.GB1677@cs181133002.pp.htv.fi>
References: <20080413012001.8d7967f4.akpm@linux-foundation.org>
	<20080413082815.GA20108@infradead.org>
	<E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu>
	<1208121358.2700.4.camel@shinybook.infradead.org>
	<20080413154459.4b2f125d.akpm@linux-foundation.org>
	<20080413234920.63711ca7@core>
	<20080413161014.cb06964c.akpm@linux-foundation.org>
	<20080415151643.GD2454@cs181133002.pp.htv.fi>
	<20080415165727.GA8783@infradead.org>
	<20080415113452.e9eacb54.akpm@linux-foundation.org>
	<20080415192432.GB1677@cs181133002.pp.htv.fi>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2008 22:24:32 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> > Look, I have repeatedly described the reason why it is probable a poor
> > tradeoff to merge code such as this.  The only response has been "well
> > we've done it before", which is largely a non-reason.
> >...
> 
> It seems you missed the first point in my email:
> 
> We do not have a stable API for external modules, and part of the deal 
> is that external modules have the chance of entering the kernel where 
> they will get API changes automatically.
> 
> 
> Plus my other point that one might argue that OMFS adds support for some 
> hardware in which case a recent commandment by Linus would require it 
> has to be merged...

That's lawyerly trickery, sorry.  Take some set of guidelines and then say
"you are thereby committed to doing X".

We're not committed to doing anything and it would be bad if we were. 
Let's apply common sense and judgement to each case on its own.

