Return-Path: <linux-kernel-owner+w=401wt.eu-S1758052AbYFYNhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052AbYFYNhl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 09:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756125AbYFYNhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 09:37:33 -0400
Received: from n21.bullet.mail.mud.yahoo.com ([68.142.206.160]:23692 "HELO
	n21.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755995AbYFYNhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 09:37:32 -0400
X-Greylist: delayed 377 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Jun 2008 09:37:32 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 330976.57149.bm@omp509.mail.sp1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=PmJ1t1IrZARnkPAmceL1GGXlUM0dMhkNnQki09GGz9JuzPn6UKRjGWnydblQW9Ps44+a29qf+LPIiUdeka3DjUnRuu2f4vamgWoE0dOJxnYMdckczCCZzuC5+DWM13jLYxunLr8UGWDq4V0zB5UQJPMcjxUi3wKraEUfONCJnkU=;
X-Mailer: YahooMailWebService/0.7.199
Date: Wed, 25 Jun 2008 06:31:14 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
Reply-To: free_beer_for_all@yahoo.com
Subject: Re: [PATCH] UTC timestamp option for FAT filesystems
To: linux-kernel@vger.kernel.org
Cc: Joe Peterson <joe@skyrush.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <223222.41388.qm@web46108.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moin moin!

May I just add a resounding YES-YES-YES to the message which was
posted earlier today as
Message-ID: <>
oh b*gger, that doesn't help when snarfing from a web archive
(voluntary use as a non-subscirber of a webmail interface prevents
me from including a References: header without more effort than I
care to do now, not that this would help)


I was actually just about to post an almost identical message today
to clean out my repository of hacks, with almost the same justifications.

In addition, may I request that not only the option `-o utc,...' be
accepted, but also as an alternate, the string `gmt', not because it's
more accurate (it isn't) but because it seems to be tradition to use
GMT+/-xxxx in lots of places.

Another justification which wasn't mentioned, but which I would put
forth, is that last time I checked, the BSDen were using UTC as their
MSDOS timestamp base, so such an option would make it easier to
exchange data between BSD and Linux machines with a normal USB stick
or flash card.  And I was doing that a year or three ago when I hacked
my hack.


I'll have to do a line-by-line comparison with my hacked code (last
applied to 2.6.24-ish) to make sure I don't have any differences, but
in order to allow users the option to specify the seeped-in-tradition-
especially-for-us-old-f*rts `gmt', here's the trivial-to-correct
section of code -- may well be different than in the patch since I
didn't save it before being kicked offline:

in  fs/fat/inode.c
    880         {Opt_debug, "debug"},
    881         {Opt_immutable, "sys_immutable"},
    882 /* XXX HACK */
    883         {Opt_utc, "utc"},
    884         {Opt_utc, "gmt"},
    885         {Opt_obsolate, "conv=binary"},
    886         {Opt_obsolate, "conv=text"},

(I use `-o utc' myself but would prefer to be flexible to alternate uses)
I notice this most when I fail to include the needed patches when
updating kernel

thanks
barry bouwsma


      

