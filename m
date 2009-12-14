Return-Path: <linux-kernel-owner+w=401wt.eu-S933052AbZLNVZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933052AbZLNVZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 16:25:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932662AbZLNVZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 16:25:34 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40706 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932632AbZLNVZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 16:25:33 -0500
Date: Mon, 14 Dec 2009 22:25:26 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Emese Revfy <re.emese@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
       akpm@linux-foundation.org
Subject: Re: [PATCH 0/1] Constify struct address_space_operations for
 2.6.32-git-053fe57ac v2
Message-ID: <20091214212526.GB9213@elf.ucw.cz>
References: <cover.1260662994.git.re.emese@gmail.com>
 <20091214003836.GD7812@parisc-linux.org>
 <4B2595E7.701@gmail.com>
 <20091214021916.GB12196@linux-sh.org>
 <4B25E47C.1010803@gmail.com>
 <20091214112656.GB1959@elf.ucw.cz>
 <20091214080049.19930729@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091214080049.19930729@infradead.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-12-14 08:00:49, Arjan van de Ven wrote:
> On Mon, 14 Dec 2009 12:26:56 +0100
> Pavel Machek <pavel@ucw.cz> wrote:
> 
> > > > Until such a consensus is reached one way or the other, please
> > > > refrain from sending hundreds of patches -- one or two are
> > > > sufficient for showing what you want to do until folks are on
> > > > board with it, as is the typical nature of mechanical changes.
> > > 
> > > I think there is consensus to constify ops variables as much as
> > > possible (e.g., Alexey's similar patches).
> > 
> > No such consensus exists. It is very clear from the patch reactions.
> 
> I for one am not opposed to using const where we could be using
> const.

I certainly object "constify ops... as much as possible". If it
uglifies the code, it should not be done. If it is as simple as adding
const to few lines, its probably ok.

But .... the patch contained huge load of 

-	int (* resume)()
+	int (* const resume)()

What is that?

> Now, a 300 patch series to lkml is not the way to do this.
> First step is to make checkpatch.pl warn about new cases.
> Second step should be to convert all definitions, but using the "one
> patch per maintainer" rule, not "one patch per file" rule. Yes it's

The zeroth step is get one small series accepted. I'd suggest VFS for
a start.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
