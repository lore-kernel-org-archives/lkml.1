Return-Path: <linux-kernel-owner+w=401wt.eu-S1754697AbZKII6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbZKII6L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 03:58:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754479AbZKII6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 03:58:10 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58416 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407AbZKII6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 03:58:09 -0500
Date: Mon, 9 Nov 2009 09:58:03 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, dhowells@redhat.com,
       hch@infradead.org, adilger@sun.com, mtk.manpages@gmail.com,
       torvalds@linux-foundation.org, drepper@gmail.com, jamie@shareable.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 resend] vfs: new O_NODE open flag
Message-ID: <20091109085803.GF4818@elf.ucw.cz>
References: <E1N60RV-0002ed-FX@pomaz-ex.szeredi.hu>
 <20091105131545.72b4e319@lxorguk.ukuu.org.uk>
 <E1N63Io-000353-KX@pomaz-ex.szeredi.hu>
 <20091106141742.GA1428@ucw.cz>
 <m17hu3xtiy.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m17hu3xtiy.fsf@fess.ebiederm.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-11-06 12:55:33, Eric W. Biederman wrote:
> Pavel Machek <pavel@ucw.cz> writes:
> 
> > On Thu 2009-11-05 15:27:06, Miklos Szeredi wrote:
> >> On Thu, 5 Nov 2009, Alan Cox wrote:
> >> > >  - re-opening normally after checking file type (there's a debate
> >> > >    whether this would have security issues, but currently we do allow
> >> > >    re-opening with increased permissions thorugh /proc/*/fd)
> >> > 
> >> > Which has already been demonstrated to be an (unfixed) security hole.
> >> 
> >> No it hasn't :)  Jamie theorized that there *might* be a real world
> >> situation where the application writer didn't anticipate this
> >> behavior.  But as to actual demonstration, we have not seen one yet, I
> >> think.
> >
> > See bugtraq, or lkml thread about symlinks with permissions. There's
> > demo script there.
> 
> Exactly a theoretical discussion, that demonstrates user space
> applications with security holes can be written if they make
> assumptions about the world that are not true.
> 
> So far no one who believes this to be a security hole has found it
> worth their while to look at nd->intent.open in proc_pid_follow_link
> and write a patch.    Pavel you started out asking for help on how
> to do that and I think I have answered the original question.


> I am tired of the whining.  If no one who is persuaded the kernel is
> wrong can be bothered to write a possibly buggy 5 line patch this is
> clearly not a security hole.

"I did not get a patch so it can't be security hole". Interesting.

I still hope to write it one day, but as I do not have untrusted users
on my systems, it is not particulary urgent. (And I still hope distro
security people do they job.)
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
