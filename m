Return-Path: <linux-kernel-owner+w=401wt.eu-S1161472AbXBHEa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161472AbXBHEa5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 23:30:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422693AbXBHEa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 23:30:57 -0500
Received: from smtp.osdl.org ([65.172.181.24]:54491 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161472AbXBHEa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 23:30:57 -0500
Date: Wed, 7 Feb 2007 20:30:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roman Zippel <zippel@linux-m68k.org>, Oleg Verych <olecom@flower.upol.cz>,
       Alexey Dobriyan <adobriyan@gmail.com>, sam@ravnborg.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kai Germaschewski <kai@germaschewski.name>
Subject: Re: [patch, fix build regression] kbuild: Kbuild.include avoid
 using spaces in call arguments
Message-Id: <20070207203047.51a95ad0.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0702071546420.8424@woody.linux-foundation.org>
References: <20070207165204.GA5537@martell.zuzino.mipt.ru>
	<Pine.LNX.4.64.0702071846180.14457@scrub.home>
	<20070207220435.GC22699@flower.upol.cz>
	<Pine.LNX.4.64.0702080029030.14457@scrub.home>
	<Pine.LNX.4.64.0702071546420.8424@woody.linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Feb 2007 15:52:54 -0800 (PST) Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 8 Feb 2007, Roman Zippel wrote:
> > 
> > Sorry, it needs more changes, the patch simply wasn't ready.
> 
> One problem I find very problematic with all the Kbuild setup is that 
> people tend to be very quiet about any build issues until they simply go 
> in.
> 
> Things don't "get ready" on their own. In other areas, people comment on 
> why they don't like patches. In Kbuild, for some reason, we often seem to 
> have this situation where people don't react at all.
> 
> Sam is great about maintaining the kernel build stuff most of the time, 
> but because it's clearly a "secondary" thing, there tends to be some 
> periods when nothing happens. Which is problematic for me..
> 
> So I end up in a situation where I just basically will apply the patches 
> just becauseif I don't, nothing ever happens. The good news is that _once_ 
> I apply them, people will usually notice problems and send in fixes fairly 
> quickly. But this particular email was NOT useful, for example.  "needs 
> more changes" is the epitome of a "not useful" comment.

Yes, kbuild is a bit of a problem at present.

I'm sitting on these:

search-a-little-harder-for-mkimage.patch
make-mkcompile_h-use-lang=c-and-lc_all=c-for-cc-v.patch
add-mailmap-for-proper-git-shortlog-output.patch
qconf-immediately-update-integer-and-string-values-in-xconfig-display-take-2.patch
qconf-relocate-search-command.patch
qconf-fix-showing-help-info-on-failed-search.patch
qconf-back-button-behaviour-normalization.patch
kbuild-remove-references-to-deprecated-prepare-all-target.patch
new-toplevel-target-headers_check_all.patch

But I'm not sure that anyone has reviewed them much.

I'll probably just push 'em and see what happens.  They seem to work.
