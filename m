Return-Path: <linux-kernel-owner+w=401wt.eu-S1755170AbYFROBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbYFROBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 10:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbYFROBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 10:01:30 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:14724 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbYFROB2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 10:01:28 -0400
Date: Wed, 18 Jun 2008 16:01:21 +0200
From: Maxim Shchetynin <maxim@linux.vnet.ibm.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Subject: Re: AZFS file system proposal
Message-ID: <20080618160121.35dd4bb3@mercedes-benz.boeblingen.de.ibm.com>
In-Reply-To: <4857D211.1030308@movial.fi>
References: <20080609104650.4f220492@mercedes-benz.boeblingen.de.ibm.com>
	<4857D211.1030308@movial.fi>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have updated my patch and will post it here in a few minutes.
Thank you very much Dmitri, all your comments are useful.

> > +static unsigned long
> > +azfs_recherche(struct inode *inode, enum azfs_direction direction,
> 
> At the risk of being damned by the entire francophone world, I'd still
> suggest using an English keyword for the function name here.

Fixed.

> > +static struct inode*
> > +azfs_new_inode(struct super_block *, struct inode *, int, dev_t);
> 
> Would it not be better to place this function prototype along with the
> bunch of macro definitions you have above into a private header?

I have a pretty few such definitions and would like to avoid adding to kernel an unnecessary .h file with just a couple of lines.

> > +	if (rc == 0)
> 
> Maybe "if (!rc)" ?

Not critical, but fixed.

> > +	void *ziel;
> 
> void *target?

Fixed.

> > +	void *quell;
> 
> void *source?

Fixed.

> > +	struct azfs_block *block, *ding, *knoten, *west, *east;
> 
> The risk of me getting damned increases with that, but maybe it would be
> better to use an English keyword for "knoten"?

Fixed.

> > +	struct azfs_super *super, *SUPER;
> 
> I think that yelling in deep desperation like that is not quite in
> agreement with the kernel coding style.

Fixed.

> An unprecedented lack of comments in this driver can hardly boost the
> reader's attention. Besides, I personally think that a kind of a design
> document could be extremely useful - basically, explain the purpose of
> the filesystem, the basic idead behind it, etc.

I have added Documentation/filesystems/azfs.txt file with a short description of what AZFS is.

-- 
Mit freundlichen Grüßen / met vriendelijke groeten / avec regards

    Maxim V. Shchetynin
    Linux Kernel Entwicklung
    IBM Deutschland Entwicklung GmbH
    Linux für Cell, Abteilung 3250
    Schönaicher Straße 220
    71032 Böblingen

Vorsitzender des Aufsichtsrats: Johann Weihen
Geschäftsführung: Herbert Kircher
Sitz der Gesellschaft: Böblingen
Registriergericht: Amtsgericht Stuttgart, HRB 243294

Fahr nur so schnell wie dein Schutzengel fliegen kann!
