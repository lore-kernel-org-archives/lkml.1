Return-Path: <linux-kernel-owner+w=401wt.eu-S1756694AbYKCVH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbYKCVH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 16:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754956AbYKCVHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 16:07:20 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:52772 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934AbYKCVHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 16:07:20 -0500
Date: Mon, 3 Nov 2008 22:08:20 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Chris Zankel <chris@zankel.net>, LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PSEUDO PATCH] xtensa: move headers files to arch/xtensa/include
Message-ID: <20081103210820.GA1847@uranus.ravnborg.org>
References: <20081103204042.GA1334@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081103204042.GA1334@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2008 at 09:40:42PM +0100, Sam Ravnborg wrote:
> Hi Chris.
> 
> Following is an untested receipe to move all header files for xtensa
> to arch/xtensa/include.

I took a second look at this and realised that I had to update
the header files located in include/asm-xtensa too with some
minimal patch updates.

And doing so I realised that irq.h has a reference to a platform specific
file so we need to add an extra directory level for platform as
we already do for variant.
So it will now look like this:
arch/xtensa/include/platform-iss/platform/*

Not a big deal to fix up but it will not be until tomorrow.
Feel free to beat me on it..

	Sam
