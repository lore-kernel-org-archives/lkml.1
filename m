Return-Path: <linux-kernel-owner+w=401wt.eu-S1753431AbYKZIQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbYKZIQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 03:16:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbYKZIQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 03:16:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50299 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751255AbYKZIQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 03:16:19 -0500
Date: Wed, 26 Nov 2008 00:15:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: john@johnmccutchan.com, arnd@arndb.de, mtk.manpages@gmail.com, hch@lst.de,
       rlove@rlove.org, linux-api@vger.kernel.org,
       linux-kernel@vger.kernel.org, pavel@suse.cz, davidn@davidnewall.com,
       Eric Paris <eparis@redhat.com>
Subject: Re: [take2] Inotify: nested attributes support.
Message-Id: <20081126001538.4b1c7c99.akpm@linux-foundation.org>
In-Reply-To: <20081126074239.GA17525@ioremap.net>
References: <20081125194234.GA24449@ioremap.net>
	<20081125162434.4feacbbf.akpm@linux-foundation.org>
	<20081126074239.GA17525@ioremap.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008 10:42:39 +0300 Evgeniy Polyakov <zbr@ioremap.net> wrote:

> Hi Andrew.
> 
> On Tue, Nov 25, 2008 at 04:24:34PM -0800, Andrew Morton (akpm@linux-foundation.org) wrote:
> > I guess I'm being more than usually thick, but I don't understand what
> > this is all about, why it was implemented, what value it provides to
> > users, etc, etc?  Why do I want scalable nested attributes in inotify??
> 
> Originally I just wanted to have a PID value in the inotify events, so
> reused cookie for that, but people rather vocally rised against this. So
> solution is to extend its structure. It would be possible just to add
> couple more bytes and store data there, but if we will want to add some
> more data into event later, we will have to implement inotify3 and so
> on. So I implemented a way to put essentially any number of new and old
> events in any order, turn then on and off, and do not care about
> possible limitation of the structure. As example I added PID, TID,
> write IO start/size and name attributes.

OK, so we have a super-duper framework which will allow us to add pids
(and other things) to inotify messages.

This still doesn't provide a reason for anyone to be interested in the
code!  Why do we want pids in inotify messages?

And how does this work give that pids are (no longer) system-wide unique?

> > I'm buried in patches which I don't understand lately, and having
> > hundreds of people send patches at one guy who doesn't understand them
> > isn't a good system.  Eric Paris is working on inotify-type things as
> > well.  It would be neat if you guys were to understand and review each
> > other's work.  Please.
> 
> No problem, I will review patches if added to the copy. I'm not
> subscsribed to linux-kernel@ so will miss them otherwise.

Thanks.
