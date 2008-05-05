Return-Path: <linux-kernel-owner+w=401wt.eu-S1761792AbYEEVIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761792AbYEEVIa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 17:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758247AbYEEVIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 17:08:21 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:36704 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755201AbYEEVIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 17:08:20 -0400
Date: Tue, 6 May 2008 00:07:12 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       sam@ravnborg.org, viro@ftp.linux.org.uk, hpa@zytor.com
Subject: Re: [rfc] the kernel workflow & trivial "global -> static" patches
	(was: Re: [2.6 patch] make sched_feat_{names,open} static)
Message-ID: <20080505210712.GD1544@cs181133002.pp.htv.fi>
References: <20080505182942.GA17139@cs181133002.pp.htv.fi> <20080505201906.GA900@elte.hu> <20080505134252.c82a64f6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080505134252.c82a64f6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 01:42:52PM -0700, Andrew Morton wrote:
> On Mon, 5 May 2008 22:19:06 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > Firstly, the practical problem: today "make namespacecheck" emits way 
> > too many false positives even on an allyesconfig build
> 
> We don't actually care about what comes out of `make namespacecheck'.  We
> care about the _difference_ in its output when a patch is applied.
> 
> So a script which reports on what changes a particular patch has upon
> namespacecheck output might be the way to go.  If it is fast enough then it
> can be run on a per-patch basis alongside checkpatch.

"make namespacecheck" works on the binary objects.

- touching header files can result in a complete rebuild
- if a patch alters which objects get built you should start with
  a clean object dir

The question is therefore basically whether a complete rebuild of an
all*config kernel is fast enough for you...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

