Return-Path: <linux-kernel-owner+w=401wt.eu-S1765332AbYBMAuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765332AbYBMAuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 19:50:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764543AbYBMAuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 19:50:14 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52424 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755782AbYBMAuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 19:50:11 -0500
Date: Tue, 12 Feb 2008 16:49:46 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <greg@kroah.com>
cc: David Miller <davem@davemloft.net>, jeff@garzik.org, arjan@infradead.org,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
In-Reply-To: <20080213002948.GA8899@kroah.com>
Message-ID: <alpine.LFD.1.00.0802121645320.2920@woody.linux-foundation.org>
References: <20080211211751.3e265754@laptopd505.fenrus.org> <20080211.221126.230471463.davem@davemloft.net> <47B1CB08.4020101@garzik.org> <20080212.155853.193190548.davem@davemloft.net> <20080213002948.GA8899@kroah.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 12 Feb 2008, Greg KH wrote:
> 
> Perhaps you need to switch to using quilt.  This is the main reason why
> I use it.

Btw, on that note: if some quilt user can send an "annotated history file" 
of their quilt usage, it's something that git really can do, and I'll see 
if I can merge (or rather, coax Junio to merge) the relevant part of stgit 
to make it possible to just basically get "quilt behaviour" for the parts 
of a git tree that you haven't pushed out yet.

A pure patch-stack will be faster at that thing than git would be (it's 
simply easier to just track patches), but on the other hand, using git 
would get some other advantages outside of the integration issue (eg the 
cherry-pick thing really is a proper three-way merge, not just an "apply 
patch", so it can do better).

It wasn't the original goal of git, but not only are really doing all the 
series management anyway (that is largely what "rebase" is all about, 
after all), but the git goals have obviously expanded over time too. 

			Linus
