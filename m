Return-Path: <linux-kernel-owner+w=401wt.eu-S1754243AbZDZSnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243AbZDZSnI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 14:43:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbZDZSmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 14:42:55 -0400
Received: from kroah.org ([198.145.64.141]:58781 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752538AbZDZSmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 14:42:55 -0400
Date: Sun, 26 Apr 2009 11:39:54 -0700
From: Greg KH <greg@kroah.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [git patches] Staging: rtxxx0: cleanup and "dumb" merge
Message-ID: <20090426183954.GA18449@kroah.com>
References: <200904261759.20923.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904261759.20923.bzolnier@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 26, 2009 at 05:59:20PM +0200, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> This patchset cleans up rt{286,287,307}0 drivers (66 KLOC removed) and then
> "dumb" (i.e. rt3070 shares code with rt2870 by including rt2870's .c files
> and depends on ifdefs to get the correct end result) merges them (142 KLOC
> removed).  All in all 208 KLOC are gone and we now use the common code for
> all three Ralink drivers.

Wonderful!

Were you able to test that this still works afterward?

> "dumb" merge is of course not the ideal solution but allows relatively easy
> verification, makes the eventual real merge much easier and in the meantime
> allows us to work with the common code for all drivers (since the initial
> merge these drivers already became slightly out-of-sync with each other).
> 
> [ I know about rt2x00 project (http://rt2x00.serialmonkey.com/) and I praise
>   their efforts.  However I still wanted to skim through the original code,
>   mainly because I heard a lot of "interesting" things about it. ;)  Then I
>   started to clean it to make reading easier and before I knew it I ended up
>   with this monster patchset... ]
> 
> 
> All changes are available in the following git tree (which is based on top
> of next-20090424):
> 
> git://git.kernel.org:/pub/scm/linux/kernel/git/bart/misc.git rtsta-for-next
> 
> [ I'm not sending individual patches to LKML (they are too big and there
>   is too many of them) but if somebody prefers to get them by mail instead
>   of grabbing them from git tree please just ping me. ]

I'll suck them in from the git tree, that's fine with me.

thanks again for doing this work, it is much appreciated.

greg k-h
