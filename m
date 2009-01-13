Return-Path: <linux-kernel-owner+w=401wt.eu-S1758603AbZAMUjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758603AbZAMUjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 15:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755068AbZAMUjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 15:39:01 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:56168 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091AbZAMUjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 15:39:00 -0500
Date: Tue, 13 Jan 2009 13:38:43 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: handygewinnspiel@gmx.de, rjw@sisk.pl, HWerner4@gmx.de,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, mchehab@infradead.org
Subject: Re: [linux-dvb] compiling on 2.6.28 broken?
Message-ID: <20090113203843.GJ29283@parisc-linux.org>
References: <20090112190420.51f75853@pedra.chehab.org> <20090112132130.6c932b85.akpm@linux-foundation.org> <20090112220624.4fbfee34@pedra.chehab.org> <20090112162337.318dd61d.akpm@linux-foundation.org> <20090113184755.87720@gmx.net> <20090113105947.9e774b69.akpm@linux-foundation.org> <20090113191757.74290@gmx.net> <20090113113700.776a94b5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113113700.776a94b5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 11:37:00AM -0800, Andrew Morton wrote:
> I'd have expected to see stat() returning -EOVERFLOW, but it isn't there.
> 
> googling around a bit seems to indcate that this might be a glibc issue:
> 
> http://sourceware.org/bugzilla/show_bug.cgi?id=1864
> http://bugs.gentoo.org/show_bug.cgi?id=146951
> 
> But the traces are all using stat64() and fstat64().  And why would it
> just start occurring now?

Maybe glibc is using the 64-bit stat calls and returning -EOVERFLOW to
the application when the results from the kernel turn out to be > 32-bit
in size?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
