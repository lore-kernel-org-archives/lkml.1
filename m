Return-Path: <linux-kernel-owner+w=401wt.eu-S1759797AbYDOSg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759797AbYDOSg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 14:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbYDOSgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 14:36:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54865 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751304AbYDOSgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 14:36:18 -0400
Date: Tue, 15 Apr 2008 11:34:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Woodhouse <dwmw2@infradead.org>,
       Miklos Szeredi <miklos@szeredi.hu>, me@bobcopeland.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
Message-Id: <20080415113452.e9eacb54.akpm@linux-foundation.org>
In-Reply-To: <20080415165727.GA8783@infradead.org>
References: <20080412205544.5e12a7d4.akpm@linux-foundation.org>
	<20080413080130.GA9622@infradead.org>
	<20080413012001.8d7967f4.akpm@linux-foundation.org>
	<20080413082815.GA20108@infradead.org>
	<E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu>
	<1208121358.2700.4.camel@shinybook.infradead.org>
	<20080413154459.4b2f125d.akpm@linux-foundation.org>
	<20080413234920.63711ca7@core>
	<20080413161014.cb06964c.akpm@linux-foundation.org>
	<20080415151643.GD2454@cs181133002.pp.htv.fi>
	<20080415165727.GA8783@infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2008 12:57:27 -0400 Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, Apr 15, 2008 at 06:16:43PM +0300, Adrian Bunk wrote:
> > We are talking about a filesystem even Christoph considers OK.
> > 
> > And who asked about the costs of merging crap like 
> > drivers/infiniband/hw/nes/ ?
> > 
> > Speaking about the latter, with Linus' logic one might argue that OMFS 
> > must not be rejected since it adds support for some hardware...
> 
> Excatly.  I find it very strange to even consider rejecting a rather
> small and very well written driver for let's say "political" reasons.

"economic" would be a far more accurate term.

Look, I have repeatedly described the reason why it is probable a poor
tradeoff to merge code such as this.  The only response has been "well
we've done it before", which is largely a non-reason.

You can continue to ignore my logic, but that won't go unnoticed.

Just as a thought exercise: should we merge a small and well-written
driver which has zero users?
