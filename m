Return-Path: <linux-kernel-owner+w=401wt.eu-S1760972AbYECHEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760972AbYECHEV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 03:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756806AbYECHEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 03:04:11 -0400
Received: from 1wt.eu ([62.212.114.60]:3730 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754968AbYECHEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 03:04:10 -0400
Date: Sat, 3 May 2008 09:03:18 +0200
From: Willy Tarreau <w@1wt.eu>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       linux-kernel@vger.kernel.org
Subject: Re: LogFS merge
Message-ID: <20080503070318.GR8474@1wt.eu>
References: <20080502133234.GA24080@logfs.org> <alpine.LFD.1.10.0805021010040.5994@woody.linux-foundation.org> <20080502202151.GB24080@logfs.org> <alpine.LFD.1.10.0805021328200.5994@woody.linux-foundation.org> <20080502213146.GD24080@logfs.org> <alpine.LFD.1.10.0805021438180.5994@woody.linux-foundation.org> <20080502215833.GG24080@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080502215833.GG24080@logfs.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2008 at 11:58:33PM +0200, Jörn Engel wrote:
> On Fri, 2 May 2008 14:39:23 -0700, Linus Torvalds wrote:
> > 
> > Quite frankly, if that's the case, I'd *much* rather see that worked on 
> > first, so that there aren't any format changes that are already known to 
> > be pending before it even gets merged.
> > 
> > Would it be at all possible to try to do that, or is it just "too far 
> > out"?
> 
> Definitely possible.  The last similar change happened in December and
> took until March until I ran out of stupid regressions from it.  Most
> likely there are still some I just haven't found yet.
> 
> The question is when to draw the line and say "This is useful as-is for
> a sufficient number of users."  I don't have a good answer to it.  I
> certainly expect more changes in the future, including format changes.
> And if we wait for them all to happen, it won't get merged this decade.

Why not merge it and mark it experimental then ? In fact, this is about
what you're looking for : reduced merge hassle and more testers.

Willy

