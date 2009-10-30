Return-Path: <linux-kernel-owner+w=401wt.eu-S932167AbZJ3OHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167AbZJ3OHv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 10:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932142AbZJ3OHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 10:07:51 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37238 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068AbZJ3OHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 10:07:50 -0400
Date: Fri, 30 Oct 2009 15:07:45 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: David Wagner <daw-news@cs.berkeley.edu>, linux-kernel@vger.kernel.org
Subject: Re: symlinks with permissions
Message-ID: <20091030140745.GC1481@ucw.cz>
References: <20091025062953.GC1391@ucw.cz> <m1zl7cb1c5.fsf@fess.ebiederm.org> <20091028081653.GA18290@elf.ucw.cz> <4AE87292.20802@schaufler-ca.com> <hcahnb$mgp$1@taverner.cs.berkeley.edu> <4AE91658.9090105@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE91658.9090105@schaufler-ca.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!


> > Perhaps take a look at Pavel's post describing the attack again?
> 
> Yeah, I did that. It still looks like the complaint is that
> /proc/8675309/fd/3 gives you the ability to gain RW access to
> an object for which you have RW access.
> 
> Look, with hard links and the various mount options available
> today you just can't count on setting the mode on a directory
> to completely protect the files that it references. Look carefully

Look again. I can count on paths if I can prevent mounts and
hardlinks. Mounts are irrelevant as they are root-only, and I was
checking for hardlinks.

> Now, ask me if I think that /proc/8675309/fd/3 is a good idea,
> and we'll have a different discussion, but from an old school

Cool, so we actually agree, and can drop this thread?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
