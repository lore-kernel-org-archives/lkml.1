Return-Path: <linux-kernel-owner+w=401wt.eu-S1764330AbXF1Mrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764330AbXF1Mrw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 08:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760761AbXF1Mro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 08:47:44 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:43216 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760734AbXF1Mrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 08:47:43 -0400
Date: Thu, 28 Jun 2007 14:48:06 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Tilman Schmidt <tilman@imap.cc>
Cc: David Miller <davem@davemloft.net>, crispin@novell.com,
       seanlkml@sympatico.ca, akpm@linux-foundation.org, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [AppArmor 00/44] AppArmor security module overview
Message-ID: <20070628124806.GS1094@stusta.de>
References: <4682D13C.6060107@novell.com> <20070627172940.1cabd5c4.seanlkml@sympatico.ca> <4682E8E1.6090701@novell.com> <20070627.160535.71552808.davem@davemloft.net> <46839B10.7040005@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46839B10.7040005@imap.cc>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2007 at 01:27:12PM +0200, Tilman Schmidt wrote:
> David Miller schrieb:
> > What you get by the code going into the upstream kernel tree is that
> > it a) adds some pseudo legitimacy to AppArmour (which I don't
> > personally think is warranted) and b) gets the work of keeping
> > apparmour working with upstream largely off of your back and in the
> > hands of the upstream community.
> > 
> > Neither of those are reasons why something should go into the tree.
> 
> I beg to differ. b) is *the* reason cited again and again on LKML
> for submitting code for inclusion in the tree. Whenever anyone
> posts anything which is remotely related to out-of-tree code,
> whether it's a question on the usage of some standard in-tree
> function, a request for help with a coding or debugging problem,
> or out-of-tree repercussions of an in-tree change, he or she
> invariably has to put up with an answer along the lines of: "put
> your code into the tree and all your problems will be solved" -
> or its sarcastic variant: "I can't find your code anywhere in
> the current kernel sources".
> 
> You can't have it both ways. Either you go around bashing
> people for maintaining their code out-of-tree or you go around
> bashing people for trying to get their code into the tree.

You have a point.

But:
Code in the kernel must fulfill some (not completely fixed) quality 
criteria. It wouldn't be good to blindly include every bit of GPL'ed 
kernel code available anywhere in the Internet.

As an example, it's highly unlikely that some external device driver 
will be accepted without the author/maintainer doing some changes for 
getting it included.

If [1] AppArmor is considered to be generally insecure or in all 
respects inferior to SELinux it doesn't belong into the kernel.

Being blessed with some of the holy penguin pee by being included in the 
kernel is considered by many users as a quality criteria.

Sure, this contradicts a bit the "get your code upstream" mantra, but 
these are two conflicting goals and there's therefore no ideal solution.

If [1] AppArmor is offering required functionality not available through 
SELinux and it's considered a correct and secure solution for these 
purposes it should go into the kernel. Otherwise, it should not go into 
the kernel.

cu
Adrian

[1] note the "if"

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

