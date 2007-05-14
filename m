Return-Path: <linux-kernel-owner+w=401wt.eu-S1757360AbXENQqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360AbXENQqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 12:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755553AbXENQqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 12:46:09 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:34224 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755472AbXENQqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 12:46:08 -0400
Date: Mon, 14 May 2007 18:46:08 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>, mgarski@post.pl,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Convert files to UTF-8 and some cleanups
Message-ID: <20070514164608.GS7984@stusta.de>
References: <4647A52A.8000709@post.pl> <4647A868.4070201@post.pl> <46486EAE.3060009@s5r6.in-berlin.de> <alpine.DEB.0.98.0705141126550.19220@sigma.j-a-k-j.com> <46488D6A.3030608@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46488D6A.3030608@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2007 at 06:25:14PM +0200, Stefan Richter wrote:
> John Anthony Kazos Jr. wrote:
> > You can't post a patch to UTF-8 in plain text, because it isn't plain 
> > text.
> 
> Of course it is, you said so...
> 
> > MTAs and MUAs mangle the hell out of them. Look back in the archives 
> > for my postings. Once you've got something in UTF-8, -*THEN*- you can post 
> > in plain inline text.
> 
> ...yourself.  Just send as
> 
> 	Content-type: text/plain; charset="utf-8"
> 
> Of course a patch like that will usually contain several character sets,
> but that's no problem as long as the byte codes are preserved and we can
> easily see how the end result looks like.  The important thing is that
> the submitter's and committer's MUAs do it right and reviewers' MUAs do
> it sort of right.  Also, nobody cares if there is still some pre-WWI
> 7bit-only MTA operated in some lone desert town.  And if some web
> archive of LKML isn't compatible to internet mail, then that's tough luck.

The problem is that the unconverted characters are always invalid UTF-8 [1],
and it's 100% correct for a MUA to convert these invalid UTF-8 
characters to replacement characters - if a MUA claims to send valid
charset="utf-8", it is simply not allowed to preserve the byte codes.

> Stefan Richter

cu
Adrian

[1] except for some cases with two or more non 7bit ASCII 
    characters in a row

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

