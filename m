Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbZF3Bjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbZF3Bjm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 21:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbZF3Bjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 21:39:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46403 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbZF3Bjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 21:39:32 -0400
Message-ID: <4A496AB3.8030008@zytor.com>
Date: Mon, 29 Jun 2009 18:30:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>, benh@kernel.crashing.org,
       paulus@samba.org
Subject: Re: [PATCH] gitignore: add *.bz2 and *.cpio to top-level; clean up
 usr/
References: <200906202056.n5KKuc9o013960@tazenda.hos.anvin.org> <1245569547.2480.18.camel@ht.satnam> <20090626222112.GB27048@uranus.ravnborg.org> <4A454A69.4050301@zytor.com> <20090626224321.GA27310@uranus.ravnborg.org> <4A4550FD.7020806@zytor.com> <20090627074706.GA30839@uranus.ravnborg.org>
In-Reply-To: <20090627074706.GA30839@uranus.ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> 
> Convinced with respect to the *.gz *.bz2 *.lzma or *.cpio extensions.
> But I will continue to be reluctant to adding global entries,
> as I have been beated from time to time by something
> that was ignored but should not have been so.
> 

In general, in the particular case of the Linux kernel tree, I think
that it's generally safe to add binary file types to the top level: we
have *extremely* few binary files in the tree, and those are clearly
special cases.

Text files or ambiguous types is another matter.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

