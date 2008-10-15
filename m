Return-Path: <linux-kernel-owner+w=401wt.eu-S1755180AbYJOWUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbYJOWUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 18:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753810AbYJOWUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 18:20:06 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:35359 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbYJOWUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 18:20:05 -0400
Date: Wed, 15 Oct 2008 16:19:48 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mingo@elte.hu, ying.huang@intel.com, linux-kernel@vger.kernel.org,
       hpa@zytor.com, tglx@linutronix.de
Subject: Re: [PATCH -mm -v5] Separate atomic_t declaration from asm/atomic.h into asm/atomic_def.h
Message-ID: <20081015221947.GN15064@parisc-linux.org>
References: <1223459070.5872.167.camel@yhuang-dev.sh.intel.com> <20081010144335.65d8153b.akpm@linux-foundation.org> <20081010214958.GA7708@elte.hu> <20081010155450.094288b4.akpm@linux-foundation.org> <20081014184718.GG15064@parisc-linux.org> <20081015151119.493ea13f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081015151119.493ea13f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2008 at 03:11:19PM -0700, Andrew Morton wrote:
> On Tue, 14 Oct 2008 12:47:19 -0600
> Matthew Wilcox <matthew@wil.cx> wrote:
> > Roman Zippel did me one better and suggested just putting it in types.h,
> > which works for me.
> 
> OK.  Or we could do the usual include/asm-generic/atomic_types.h and
> then architectures can choose to include that if it is appropriate.
> 
> Anyway the good news is that this concept is an addition to rather than
> a replacement of this current patch.

Um, no.  Roman and I are against the creation of a new file.  Just put
the atomic_t definition in <linux/types.h>.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
