Return-Path: <linux-kernel-owner+w=401wt.eu-S1759406AbXFOXYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759406AbXFOXYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 19:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757064AbXFOXYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 19:24:14 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36645 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754098AbXFOXYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 19:24:13 -0400
Date: Fri, 15 Jun 2007 16:23:30 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
cc: Rich Coe <Richard.Coe@med.ge.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: RFC: Re: PATCH: udf fs corruption on linux-2.6
In-Reply-To: <20070615160944.GA29775@duck.suse.cz>
Message-ID: <alpine.LFD.0.98.0706151622010.14121@woody.linux-foundation.org>
References: <20070613154803.a1ad874a.Richard.Coe@med.ge.com>
 <20070614163218.1d75dda4.Richard.Coe@med.ge.com>
 <alpine.LFD.0.98.0706141511110.14121@woody.linux-foundation.org>
 <20070615160944.GA29775@duck.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 15 Jun 2007, Jan Kara wrote:
>
>   My fix for this problem is already sitting in Andrew's patch queue
> (http://lkml.org/lkml/2007/6/11/79). Rich's patch still has a problem - you
> cannot call udf_discard_prealloc() from drop_inode() because it is called
> under inode_lock and thus you cannot call e.g. mark_inode_dirty(). I've done
> that mistake too ;). So please don't apply the patch.

Ok, dropped, will depend on Andrew to forward it to me. It may miss the 
(already late) -rc5 I was hoping to release today, but I'll cc Andrew on 
this, and maybe I'll get disorganized and just end up delaying -rc5 even 
more ;)

		Linus
