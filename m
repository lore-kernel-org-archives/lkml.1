Return-Path: <linux-kernel-owner+w=401wt.eu-S1758475AbYLLDHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758475AbYLLDHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 22:07:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757320AbYLLDHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 22:07:10 -0500
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:31548 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752079AbYLLDHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 22:07:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Dbl0AMUyj9yZOKhumlX46ciN++8AEYi+urTE8XlPHpHT3csZGZzio18yNG8496cnA1+aZH+MFEaAGQEQY9m1F9zvO8Nci0ZBzYsNj6jVMd6s/ZOoEIRfN8T4U+GhA81nvffWoPUW9VNexlGQ3ETCLzJ1vIvWHBCq2RFa0m8y0dw=  ;
X-YMail-OSG: lqv_GncVM1kbthhG17aks3g3KQgN.CKzUUzMYv3Ki7FccRBCumIXbV259uKGfR0akA18bnZskMlPB_3UwcgJ2pzZsrXBi_MqgQHbIVW6bj_CpgVX_QshjV7GdjzDxMPWffjgacggqjud5inYbieaQXOSf9a3wxyGoe_gjLVTGT9zMUlW0oQ.1zOYZEII
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux 2.6.28-rc8
Date: Fri, 12 Dec 2008 13:07:02 +1000
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.0812101651130.3340@localhost.localdomain> <200812111945.53399.nickpiggin@yahoo.com.au> <20081211190225.0de48422.akpm@linux-foundation.org>
In-Reply-To: <20081211190225.0de48422.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812121407.02599.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 December 2008 14:02, Andrew Morton wrote:
> On Thu, 11 Dec 2008 19:45:53 +1100 Nick Piggin <nickpiggin@yahoo.com.au> 
wrote:
> > > > I still have one fix for a reported regression (softlink code doesn't
> > > > honour GFP_NOFS, caused by a patch of mine). Posted a couple of weeks
> > > > ago, but it didn't get anywhere.
> > >
> > > I don't have a clue what you're talking about.
> > >
> > > <greps the tree>
> > >
> > > ./fs/affs/inode.c:      case ST_SOFTLINK:
> > > ./fs/affs/namei.c:      error = affs_add_entry(dir, inode, dentry,
> > > ST_SOFTLINK); ./include/linux/amigaffs.h:#define ST_SOFTLINK  3
> > >
> > > really?
> >
> > Oh, I thought I cc'ed you...
> >
> > http://marc.info/?l=linux-fsdevel&m=122777850302085&w=2
> > http://marc.info/?l=linux-fsdevel&m=122777852502093&w=2
>
> yes, but that stuff went round and round in circles and ended up all in
> the air.

Hmm, OK. I think we ended up agreeing after some review and things
fixed since my original posting.

But it was an honest question -- is this too late to go in 2.6.28,
given that it has been present in earlier releases too? Maybe if the
release date is pushed to after Christmas, then there is enough time.
Otherwise, perhaps it should go upstream afterwards, then filter into
-stable?

Anyway, I'll repost them, in case you'd care to put them in -mm in
the meantime.
