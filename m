Return-Path: <linux-kernel-owner+w=401wt.eu-S1756809AbYDNMvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809AbYDNMvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 08:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbYDNMvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 08:51:04 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:55043 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbYDNMvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 08:51:03 -0400
To: dwmw2@infradead.org
CC: miklos@szeredi.hu, jamie@shareable.org, hch@infradead.org,
       akpm@linux-foundation.org, me@bobcopeland.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-reply-to: <1208171143.31695.54.camel@pmac.infradead.org> (message from
	David Woodhouse on Mon, 14 Apr 2008 12:05:43 +0100)
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
References: <1208041121-26787-1-git-send-email-me@bobcopeland.com>
	 <20080412170304.54f139e2.akpm@linux-foundation.org>
	 <20080413033344.GA27494@hash.localnet>
	 <20080412205544.5e12a7d4.akpm@linux-foundation.org>
	 <20080413080130.GA9622@infradead.org>
	 <20080413012001.8d7967f4.akpm@linux-foundation.org>
	 <20080413082815.GA20108@infradead.org>
	 <E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu>
	 <1208121358.2700.4.camel@shinybook.infradead.org>
	 <E1JlJ4U-0004xa-Sf@pomaz-ex.szeredi.hu>
	 <20080414094215.GD2076@shareable.org>
	 <E1JlLRt-0005JD-QR@pomaz-ex.szeredi.hu> <1208171143.31695.54.camel@pmac.infradead.org>
Message-Id: <E1JlO90-0005gJ-MH@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 14 Apr 2008 14:50:46 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 2008-04-14 at 11:58 +0200, Miklos Szeredi wrote:
> > Oh, you mean without having to run the whole kernel around the
> > filesystem?  Well, that's a bit more tricky: filesystems use not just
> > the VFS API, but the block, VM, SLAB, etc. APIs as well.  Porting all
> > of these to userspace and keeping them in sync with the kernel changes
> > doesn't sound much fun.
> 
> That would be UML :)
> 
> But seriously -- wouldn't our time be better spent on improving error
> handling in the kernel,

Sure, but that needs reviewer time, tester time and developer time.
All of those is limited, and for a piece of code with <100 users and
>1kloc it may not be worth it.

But if people do it for fun, or for having a simple example code to
look at, I have no problem with that :)

Miklos
