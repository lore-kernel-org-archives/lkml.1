Return-Path: <linux-kernel-owner+w=401wt.eu-S1752696AbZKGR6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbZKGR6t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 12:58:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbZKGR6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 12:58:48 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38778 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbZKGR6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 12:58:48 -0500
Date: Sat, 7 Nov 2009 18:58:46 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, alan@lxorguk.ukuu.org.uk,
       akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, dhowells@redhat.com,
       hch@infradead.org, adilger@sun.com, mtk.manpages@gmail.com,
       torvalds@linux-foundation.org, drepper@gmail.com, jamie@shareable.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 resend] vfs: new O_NODE open flag
Message-ID: <20091107175846.GA5361@elf.ucw.cz>
References: <E1N60RV-0002ed-FX@pomaz-ex.szeredi.hu>
 <20091105131545.72b4e319@lxorguk.ukuu.org.uk>
 <E1N63Io-000353-KX@pomaz-ex.szeredi.hu>
 <20091106141742.GA1428@ucw.cz>
 <m17hu3xtiy.fsf@fess.ebiederm.org>
 <E1N6g3B-0006UZ-1R@pomaz-ex.szeredi.hu>
 <m13a4qsiap.fsf@fess.ebiederm.org>
 <E1N6jWB-0006gu-2u@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1N6jWB-0006gu-2u@pomaz-ex.szeredi.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > I'm more and more convinced, that the current behavior is the right
> > > one.
> > 
> > I think the 15 or so years we have had the current behavior without
> > problems is persuasive.
> > 
> > I think it is an interesting puzzle on how to get dup instead of
> > reopen as there are cases where that could be useful behavior as well.
> 
> Probably doable with ptrace().

Confused, where does ptrace fit the picture?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
