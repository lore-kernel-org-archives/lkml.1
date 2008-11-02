Return-Path: <linux-kernel-owner+w=401wt.eu-S1754725AbYKBUW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbYKBUW3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 15:22:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754058AbYKBUWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 15:22:20 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:37976 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055AbYKBUWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 15:22:19 -0500
Date: Sun, 2 Nov 2008 21:23:36 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tags: link from CONFIG_x to 'config x' as well
Message-ID: <20081102202336.GB4330@uranus.ravnborg.org>
References: <20081031172938.GA13896@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081031172938.GA13896@x200.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 08:29:38PM +0300, Alexey Dobriyan wrote:
> Inability to jump from CONFIG_ symbol in source to symbol definition in 
> Kconfig is very, very annoying. You'll jump to useless entry in autoconf.h,
> if it exists at all.
> 
> No more.

Hi Alexey.

Based on the number of patches hitting tags/cscope support at the moment
it is becoming obvious that this have to live outside the top-level
Makefile.
So any improvements in this area has to start with ripping
it all out of the top-level Makefile and add it to a shell
script in scripts/tags.sh (or similar).

If no-one betas me I will do so when I start to look into
non-bugfixes for kbuild.

So I will not take your patch right now. Not because it is
wrong, but simple to avoid changes to the top-level Makefile
when this must happen in a shell script.

	Sam
