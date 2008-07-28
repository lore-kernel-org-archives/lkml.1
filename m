Return-Path: <linux-kernel-owner+w=401wt.eu-S1758351AbYG1PqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351AbYG1PqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 11:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbYG1PqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 11:46:08 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:32967 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554AbYG1PqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 11:46:07 -0400
Date: Mon, 28 Jul 2008 18:45:25 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: 463 kernel developers missing!
Message-ID: <20080728154525.GE30612@cs181140183.pp.htv.fi>
References: <9e4733910807280745l248801ebp134e77fc1ac70c02@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9e4733910807280745l248801ebp134e77fc1ac70c02@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 10:45:59AM -0400, Jon Smirl wrote:
> Here's a new .mailmap file for the kernel that cleans up the horrible
> mess of names and email addresses in the log.  To use it put it at the
> root of your kernel tree and type 'git shortlog'. Before the clean up
> there were 4,284 developers, after 3,821. There are 5,051 unique
> emails.
> 
> The mailmap file contains all email addresses that have been used to
> submit patches to the kernel. Don't freak out about your email address
> being in the file, if it is in the file it is already in Google since
> the kernel log is already in Google.
> 
> Putting all the email addresses and names into this file allows it to
> be used as a basis for future validation. Since I don't know perl, can
> someone whip up a patch to checkpatch.pl that validates the emails in
> new patches against the ones in mailmap? Then if you aren't in mailmap
> part of your commit needs to include a new entry for mailmap.
> 
> Another useful script would take the output of "git log | grep ^Author
> | sort -u" and diff the list of email address against the mailmap
> file.  Any new emails found are new people that need to be added to
> mailmap. Only the emails should be checked, not the names.
> 
> Please excuse any errors I made in the clean up process, a large
> portion of it was done manually. After the base file is in we can
> patch it to fix the errors. For those of you using a dozen aliases,
> you might want to order them so that your current email is the last
> one in the list. James Bottomley has the most aliases, 13.

The charset of the names is pretty random - that should be fixed at some 
point.

> PS It's not a diff because it would be too big to post.

200 kB would be OK for linux-kernel (AFAIR the current limit
is 400 kB). But to prevent charset problems a compressed attachment 
might make sense...

> Jon Smirl

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

