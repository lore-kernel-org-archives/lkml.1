Return-Path: <linux-kernel-owner+w=401wt.eu-S1757214AbZLJTts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214AbZLJTts (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 14:49:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756080AbZLJTtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 14:49:47 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:35977 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841AbZLJTtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 14:49:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=uvTS0yEI96BrNoJudvB4Lf5+wXG79bl29zEKXnmFC66gC9YVJNbyltlTl2oLSQW6m/
         Whw4knkafvvIggjYRqbt2HNIXml3QjqwDrztUisxeIjA3UO50WQvLSyG9jxQIt6A+Fl4
         IubDl+8zoBdOEKsDjBAWXOxVURwmA08Kt/hKA=
Date: Thu, 10 Dec 2009 21:49:48 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Maarten Maathuis <madman2003@gmail.com>, Dave Airlie <airlied@linux.ie>,
       dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Xavier Bestel <xavier.bestel@free.fr>
Subject: Re: [git pull] drm
Message-ID: <20091210214948.3d3c958c@daedalus.pq.iki.fi>
In-Reply-To: <alpine.LFD.2.00.0912101035140.3560@localhost.localdomain>
References: <alpine.DEB.2.00.0912100603070.24701@skynet.skynet.ie>
	<alpine.LFD.2.00.0912100716470.3560@localhost.localdomain>
	<1260459601.18520.26.camel@skunk>
	<alpine.LFD.2.00.0912100823220.3560@localhost.localdomain>
	<6d4bc9fc0912100940l1d2954d0k187ae54bf44a23f5@mail.gmail.com>
	<alpine.LFD.2.00.0912101035140.3560@localhost.localdomain>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Dec 2009 10:42:46 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 10 Dec 2009, Maarten Maathuis wrote:
> > 
> > You assume that Red Hat has full control over the project,
> > which i don't think is the case. The reason it isn't in staging
> > yet (as far as i know) is because of some questions over the
> > copyright of some (essential) microcode. Either the question
> > needs to be answered, or it has to be reverse engineered to the
> > point that it's possible to generate it.
> 
> I think people are just making up excuses, as evidenced by the
> fact that you're quoting a different excuse than I've heard
> before.

That is because priorities change. The ABI has not seen changes
for some time now, so it's probably not an issue anymore. And it
is not an issue for staging. The other issue has become more
important. That said, there are features that likely require
revising the ABI at some point, and we know about those already.

> The fact is, if there are license questions, then Fedora had
> better not be distributing the code either. And they clearly are.

I've no idea how they pulled that, but I have not heard anyone
say that there are *no* legal issues at all.

> I've heard the "but it's hard to merge" excuse too - which I also
> know is bullshit, because I can look at the git tree Fedora
> apparently uses, and it merges without any conflicts what-so-ever.

No-one has said that about Nouveau, have they?

> The most common excuse is the "oh, but it might change" crap. But
> that's not even a very good excuse to start with, and it's what
> staging is for anyway.

Yes, and to my understanding Nouveau is past that excuse. People
just like to quote what they heard last.

The big question is what we call ctxprogs: binary blobs that are
clearly executable, running somewhere in the GPU. No-one seems
to know, if those are copyrightable, or if they can be redistributed.
In their current form, they have been recorded from the nvidia
proprietary driver using mmiotrace, and copied verbatim for each
card type.

Would you be willing to pull that kind of stuff into Linux?

I would not even dare sending them to the Linux firmware
repository, since they have some license requirements, too.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
