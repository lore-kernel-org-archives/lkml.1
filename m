Return-Path: <linux-kernel-owner+w=401wt.eu-S1764085AbZAPGBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764085AbZAPGBi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 01:01:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624AbZAPGB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 01:01:27 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:38872 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbZAPGB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 01:01:26 -0500
Date: Thu, 15 Jan 2009 23:01:24 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Nick Piggin <npiggin@suse.de>
Cc: MinChan Kim <minchan.kim@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, linux-parisc@vger.kernel.org
Subject: Re: [PATCH] Remove needless flush_dcache_page call
Message-ID: <20090116060124.GG31013@parisc-linux.org>
References: <20090116052804.GA18737@barrios-desktop> <20090116053338.GC31013@parisc-linux.org> <20090116055119.GA6515@barrios-desktop> <20090116055927.GA22810@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090116055927.GA22810@wotan.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2009 at 06:59:27AM +0100, Nick Piggin wrote:
> But there are quite possibly holes around here because not as much testing
> is done on CPUs with these kinds of caches. Eg. brd probably should be
> doing a flush_dcache_page in the rw == WRITE direction AFAIKS, so it picks
> up user aliases here.

Nick, if you wanted me to schlep a parisc machine to LCA for you, you
needed to ask me *before* I got as far as Vancouver ;-)

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
