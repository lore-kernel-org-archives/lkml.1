Return-Path: <linux-kernel-owner+w=401wt.eu-S1761720AbYETR4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761720AbYETR4k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 13:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755615AbYETR4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 13:56:32 -0400
Received: from [198.99.130.12] ([198.99.130.12]:41614 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753852AbYETR4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 13:56:31 -0400
Date: Tue, 20 May 2008 13:56:24 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Tom Spink <tspink@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: UML fails to locate address space
Message-ID: <20080520175624.GA10889@c2.user-mode-linux.org>
References: <7b9198260805200408k1d6b70a8xc7e4c24106e5020f@mail.gmail.com> <20080520135238.GB6990@c2.user-mode-linux.org> <7b9198260805200659p6ed28403t9b0b0ea995f158d5@mail.gmail.com> <20080520161047.GA9598@c2.user-mode-linux.org> <7b9198260805200943x6fb15512o7ba35a40d006b215@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b9198260805200943x6fb15512o7ba35a40d006b215@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 05:43:17PM +0100, Tom Spink wrote:
> I suspected this type of foul-play, and tried altering bottom to 1,
> but this didn't work.  So, I took out the page_ok test, and it
> continued booting.  So I went back, put the test back in and
> incremented bottom until I got to 16.  It worked at 16. :-)

Heh, I guess they were also worried about up to 64K offsets off a NULL
pointer too.

> Is this something that can be fixed, or would a config option be
> appropriate?

This was done in order to remove config options.  It might be
reasonable to effectively do what you did, and search for the lowest
address at which mmap works and start from there.

> I am willing to blame Ubuntu, but unfortunately, I can't find an
> online resource of their patches.

https://wiki.ubuntu.com/KernelGitGuide lists a bunch of git repos.
Tell me which one applies to you and I'll take a look.

     	      	  Jeff


-- 
Work email - jdike at linux dot intel dot com
