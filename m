Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbZC2L6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbZC2L6s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 07:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753449AbZC2L6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 07:58:39 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42655 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345AbZC2L6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 07:58:38 -0400
Date: Sun, 29 Mar 2009 13:58:30 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Bodo Eggert <7eggert@gmx.de>
Cc: James Morris <jmorris@namei.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: TOMOYO in linux-next
Message-ID: <20090329115830.GA15492@elf.ucw.cz>
References: <ck5CF-5mU-11@gated-at.bofh.it> <E1Ln8MC-0001RR-1E@be1.7eggert.dyndns.org> <20090327114224.GF2585@elf.ucw.cz> <alpine.LSU.0.999.0903271354290.5610@be1.lrz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.0.999.0903271354290.5610@be1.lrz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-03-27 14:04:32, Bodo Eggert wrote:
> On Fri, 27 Mar 2009, Pavel Machek wrote:
> > On Fri 2009-03-27 10:28:07, Bodo Eggert wrote:
> > > Pavel Machek <pavel@ucw.cz> wrote:
> 
> > > > I don't think merging that is good idea. Security should be doable
> > > > without making shell-like glob matching...
> > > 
> > > How do you suppose a security system should handle mozilla modifying
> > > ~/.bashrc differently from downloading something to ~/pr0n.jpg?
> > 
> > How does shell-like glob matching help there? You'd need to parse
> > /etc/passwd to find all ~ directories...
> 
> That is, if you'd use HOME=`dd if=/dev/urandom ...`.
> 
> If you have your users in /home/user, you can tell /home/*/.*
> is bad, /home/*/[^.]* is OK.

On the common systems I know of, homes are spread over different
volumes and different directories. TOMOYO's wildcards do _not_ solve
this particular problems.

> How would you exclude mozilla from writing to .* then? ".a" is bad,
> ".b" is bad ...? or "A" is OK, "a" is OK, "zzzzzzzzzzzzz" is OK"?
> Either way, you'd need several universes to store the security profile.

What is magic about .* files? I want mozilla to store the pictures as
.naughty.picture.jpg -- I don't see anything wrong with that.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
