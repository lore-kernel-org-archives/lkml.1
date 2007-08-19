Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891AbXHSNmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbXHSNmV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 09:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbXHSNmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 09:42:11 -0400
Received: from 1wt.eu ([62.212.114.60]:1747 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752839AbXHSNmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 09:42:10 -0400
Date: Sun, 19 Aug 2007 15:33:02 +0200
From: Willy Tarreau <w@1wt.eu>
To: Marc Perkel <mperkel@yahoo.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: The vi editor causes brain damage
Message-ID: <20070819133302.GA13719@1wt.eu>
References: <20070819072135.GQ6002@1wt.eu> <952949.96475.qm@web52503.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <952949.96475.qm@web52503.mail.re2.yahoo.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 19, 2007 at 06:22:37AM -0700, Marc Perkel wrote:
> The important point that you are missing here is that
> the Linux world is willing to live with an rm command
> that is broken and the Windows and DOS world isn't.

The important point you are missing is that it is not the rm command
which is broken. Either it's *all* commands or it's *your* way of
thinking how they should work.

I could play your game and say the "type" command is broken under
DOS. Why can't I do "type *" under DOS while I can do "cat *" under
linux ? For the exact same reason : the "*" is not processed at
the same place. Unix initially chose to process it in the caller,
and DOS later chose to process it in the callee. Neither is right,
neither is wrong, those are just two different approaches which may
be justified in their context. Having discovered DOS at 1.25 which
did not even support directories, I certainly can say that missing
globbing was not a problem at this time!

> This isn't about the rm command it's about programming
> standards. It's about that the Linux community isn't
> committed to getting it right.

It has nothing to do with programming standards, the rm command works
exactly like all others. Touch does the same, mv does the same, etc...
Educate yourself before stating idiocies like this !

> Just like my thinking outside the box thread when I
> try to say "this is broken" people don't go fix it.
> Instead I get an explanation why Linux isn't capable
> of having an rm command that will delete an unlimited
> number of files.

$ rm -rf $DIR will remove an unlimited number of files in this directory.

If you want to make a special case of "rm", then implement the special
case in the command and make it possible to pass it a globbing expression
just like you can do with find. But this will be useless.

> I bet there are Microsoft people out there laughing at
> this.

Oh yes, they are surely laughing at you, but at the same time they may
feel sad to be defended by people puting such stupid statements in public.

> THINK ABOUT IT PEOPLE !!!
> 
> 20 years, a million programmers, tens of millions of
> users and RM is BROKEN. Am I the only one who has a
> problem with this? If so - I'm normal - and Linux is a
> cult.

Yes, I really think you're the only one who has this problem. Don't you
think that among those tens of millions of users, none of them has ever
had to remove a directory full of files in 20 years ? Please stop taking
yourself for the center of the world and buy a "unix for newbies" book
instead of complaining the world is not like you would like it to be.

Willy

