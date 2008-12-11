Return-Path: <linux-kernel-owner+w=401wt.eu-S1755335AbYLKIqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbYLKIqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 03:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbYLKIqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 03:46:03 -0500
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:25052 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753503AbYLKIqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 03:46:00 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ZwUNBu8dBslsYdMMDv99wFRuSGGIlHNtGSufFZ9x0Dc08M1siqHqfZ488HWpxP+YfH5qRbjE7/BH0ZU7uxF3qpH15LWeC0IB0/GN+H1riB2nEYBsmQcqlhyGgOJV0UTz+Oy6x3a0KAysgt8ek37qbOdWKNuxEa/8fdBoxSMyfCM=  ;
X-YMail-OSG: dX9dR18VM1mnVDCuACrPC5RzPUYk.HJxf3yBSwwW4itgMZVCEBACv3LWZ8Hd64GhzoEh.ca0IokOinaNcsx2mHhcTYk3P_sSSujMIE8luQarJDRv9POMsWt0.Wf.bqKFf3327IpIqevY_DmqyhH8C0Oc9J9ZmcRfp6wAtQ6AvcOu.vcYnT_rCEypwtuN
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux 2.6.28-rc8
Date: Thu, 11 Dec 2008 19:45:53 +1100
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.0812101651130.3340@localhost.localdomain> <200812111857.36862.nickpiggin@yahoo.com.au> <20081211000730.2e0334d0.akpm@linux-foundation.org>
In-Reply-To: <20081211000730.2e0334d0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812111945.53399.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 December 2008 19:07, Andrew Morton wrote:
> On Thu, 11 Dec 2008 18:57:36 +1100 Nick Piggin <nickpiggin@yahoo.com.au> 
wrote:
> > On Thursday 11 December 2008 12:04, Linus Torvalds wrote:
> > > Nothing overly exciting here. Lots of small things, mostly in drivers
> > > (with some defconfig updates for m68k and mips making the diffs
> > > bigger).
> > >
> > > There's some uncomfortably big changes to the intel DRI code, but most
> > > of that is all about fixes to the new i916 "GEM" code that is only used
> > > by development X servers, and is a new feature, so it shouldn't be able
> > > to cause regressions.
> > >
> > > Perhaps more interesting is simply the release scheduling issue. I'm
> > > getting slowly ready to do a real 2.6.28, but I don't think anybody
> > > really wants the merge window to be around the holidays. So the
> > > question is really whether to
> > >
> > >  (a) just make the -rc's go on a few more weeks, and do 2.6.28 after
> > > xmas
> > >
> > >      I like this, because alledgely people are debugging things, and
> > > we'd get a more stable 2.6.28.
> >
> > I still have one fix for a reported regression (softlink code doesn't
> > honour GFP_NOFS, caused by a patch of mine). Posted a couple of weeks
> > ago, but it didn't get anywhere.
>
> I don't have a clue what you're talking about.
>
> <greps the tree>
>
> ./fs/affs/inode.c:      case ST_SOFTLINK:
> ./fs/affs/namei.c:      error = affs_add_entry(dir, inode, dentry,
> ST_SOFTLINK); ./include/linux/amigaffs.h:#define ST_SOFTLINK  3
>
> really?

Oh, I thought I cc'ed you...

http://marc.info/?l=linux-fsdevel&m=122777850302085&w=2
http://marc.info/?l=linux-fsdevel&m=122777852502093&w=2
