Return-Path: <linux-kernel-owner+w=401wt.eu-S1758841AbXEPN6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841AbXEPN6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 09:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756047AbXEPN6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 09:58:09 -0400
Received: from lazybastard.de ([212.112.238.170]:52284 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756039AbXEPN6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 09:58:07 -0400
Date: Wed, 16 May 2007 15:53:19 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: John Stoffel <john@stoffel.org>
Cc: Jamie Lokier <jamie@shareable.org>, David Woodhouse <dwmw2@infradead.org>,
       akpm@osdl.org, Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Albert Cahalan <acahalan@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Ingo Oeser <ioe-lkml@rameria.de>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-mtd@lists.infradead.org,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-fsdevel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] LogFS take three
Message-ID: <20070516135318.GK5472@lazybastard.org>
References: <20070515151919.GA32510@lazybastard.org> <17994.1241.436841.681216@stoffel.org> <20070515191926.GB1220@lazybastard.org> <1179291255.2859.195.camel@shinybook.infradead.org> <20070516110933.GA5472@lazybastard.org> <20070516113434.GC20482@mail.shareable.org> <20070516115003.GD5472@lazybastard.org> <17995.2550.581854.8393@stoffel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <17995.2550.581854.8393@stoffel.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007 09:41:10 -0400, John Stoffel wrote:
> JÃ¶rn> On Wed, 16 May 2007 12:34:34 +0100, Jamie Lokier wrote:
> 
> JÃ¶rn> How many of you have worked for IBM before?  Vowels are not
> evil. ;)
> 
> Nope, they're not.  I just think that LogFS isn't descriptive enough,
> or more accurately, is the *wrong* description of this filesystem.  

That was the whole point.  JFFS2, the journaling flash filesystem, is a
strictly log-structured filesystem.  LogFS has a journal.

It is also the filesystem that tries to scale logarithmically, as Arnd
has noted.  Maybe I should call it Log2 to emphesize this point.  Log1
would be horrible scalability.

> flashfs works for me.  It's longer, but hey, that's ok.  Even flshfs
> might work.  Oh wait, flesh?  flash?  flush?  Too confusing... :-)   

Maybe.  FFS or flash filesystem already exists.  And YAFFS, yet another
flash filesystem, would be older than flashfs.

My experience is that no matter which name I pick, people will complain
anyway.  Previous suggestions included:
jffs3
jefs
engelfs
poofs
crapfs
sweetfs
cutefs
dynamic journaling fs - djofs
tfsfkal - the file system formerly known as logfs

Plus today:
FFFS
flashfs
fredfs
bob
shizzle

Imo they all suck.  LogFS also sucks, but it allows me to make a stupid
joke and keep my logfs.org domain.

Jörn

-- 
There are two ways of constructing a software design: one way is to make
it so simple that there are obviously no deficiencies, and the other is
to make it so complicated that there are no obvious deficiencies.
-- C. A. R. Hoare
