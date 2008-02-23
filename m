Return-Path: <linux-kernel-owner+w=401wt.eu-S932119AbYBWBhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119AbYBWBhZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 20:37:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754320AbYBWBhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 20:37:04 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:51855 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbYBWBhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 20:37:03 -0500
Date: Sat, 23 Feb 2008 02:37:00 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Chase Venters <chase.venters@clientec.com>
cc: linux-kernel@vger.kernel.org, git@vger.kernel.org
Subject: Re: Question about your git habits
In-Reply-To: <200802221837.37680.chase.venters@clientec.com>
Message-ID: <Pine.LNX.4.64.0802230221140.21077@fbirervta.pbzchgretzou.qr>
References: <200802221837.37680.chase.venters@clientec.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 22 2008 18:37, Chase Venters wrote:
>
>I've been making myself more familiar with git lately and I'm curious what 
>habits others have adopted. (I know there are a few documents in circulation 
>that deal with using git to work on the kernel but I don't think this has 
>been specifically covered).
>
>My question is: If you're working on multiple things at once,

Impossible; Humans only have one core with only seven registers --
according to CodingStyle chapter 6 paragraph 4.

>do you tend to clone the entire repository repeatedly into a series
>of separate working directories

Too time consuming on consumer drives with projects the size of Linux.

>and do your work there, then pull
>that work (possibly comprising a series of "temporary" commits) back
>into a separate local master respository with --squash, either into
>"master" or into a branch containing the new feature?

No, just commit the current unfinished work to a new branch and deal
with it later (cherry-pick, rebase, reset --soft, commit --amend -i,
you name it). Or if all else fails, use git-stash.

You do not have to push these temporary branches at all, so it is
much nicer than svn. (Once all the work is done and cleanly in
master, you can kill off all branches without having a record
of their previous existence.)

>Or perhaps you create a temporary topical branch for each thing you
>are working on, and commit arbitrary changes then checkout another
>branch when you need to change gears, finally --squashing the
>intermediate commits when a particular piece of work is done?

if I don't collect arbitrary changes, I don't need squashing
(see reset --soft/amend above)

