Return-Path: <linux-kernel-owner+w=401wt.eu-S1757475AbZKSWaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475AbZKSWaU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 17:30:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757206AbZKSWaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 17:30:20 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56931 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589AbZKSWaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 17:30:18 -0500
Date: Thu, 19 Nov 2009 23:30:18 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jeff Layton <jlayton@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] procfs: make /proc style symlinks behave like "normal"
 symlinks
Message-ID: <20091119223018.GC11212@elf.ucw.cz>
References: <1258638251-20034-1-git-send-email-jlayton@redhat.com>
 <m14ooq5tq3.fsf@fess.ebiederm.org>
 <20091119132833.30bc93a4@barsoom.rdu.redhat.com>
 <m1skca2vi3.fsf@fess.ebiederm.org>
 <20091119143555.7851953f@barsoom.rdu.redhat.com>
 <20091119213935.GA11212@elf.ucw.cz>
 <m1vdh6uqjn.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1vdh6uqjn.fsf@fess.ebiederm.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

(Sorry, missed Cc's first time).

> >> Adding the missing revalidations is fine, but I don't believe that
> >> helps to fix Pavel's issue. I'll go back and take a more careful look
> >> at the suggestion that Miklos made and see whether it makes sense to
> >> implement a new FS_* flag for this, and see what it'll take to fix
> >> Pavel's issue.
> >
> > One posibility would be to make open(/proc/XX/fd/XX) behave like
> > dup(). That should solve the NFS problems, too, no?
> 
> Not for bind mounts, and the revalidate in follow_mounts is a bug regardless.

Really? So dup() is also broken on nfs? How do bind mounts affect
dup()?
                                                                        Pavel   
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
