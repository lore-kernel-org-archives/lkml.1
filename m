Return-Path: <linux-kernel-owner+w=401wt.eu-S1752956AbYKZHmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956AbYKZHmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 02:42:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751014AbYKZHml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 02:42:41 -0500
Received: from tservice.net.ru ([195.178.208.66]:46203 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916AbYKZHml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 02:42:41 -0500
Date: Wed, 26 Nov 2008 10:42:39 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: john@johnmccutchan.com, arnd@arndb.de, mtk.manpages@gmail.com, hch@lst.de,
       rlove@rlove.org, linux-api@vger.kernel.org,
       linux-kernel@vger.kernel.org, pavel@suse.cz, davidn@davidnewall.com,
       Eric Paris <eparis@redhat.com>
Subject: Re: [take2] Inotify: nested attributes support.
Message-ID: <20081126074239.GA17525@ioremap.net>
References: <20081125194234.GA24449@ioremap.net> <20081125162434.4feacbbf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081125162434.4feacbbf.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew.

On Tue, Nov 25, 2008 at 04:24:34PM -0800, Andrew Morton (akpm@linux-foundation.org) wrote:
> I guess I'm being more than usually thick, but I don't understand what
> this is all about, why it was implemented, what value it provides to
> users, etc, etc?  Why do I want scalable nested attributes in inotify??

Originally I just wanted to have a PID value in the inotify events, so
reused cookie for that, but people rather vocally rised against this. So
solution is to extend its structure. It would be possible just to add
couple more bytes and store data there, but if we will want to add some
more data into event later, we will have to implement inotify3 and so
on. So I implemented a way to put essentially any number of new and old
events in any order, turn then on and off, and do not care about
possible limitation of the structure. As example I added PID, TID,
write IO start/size and name attributes.

> I'm buried in patches which I don't understand lately, and having
> hundreds of people send patches at one guy who doesn't understand them
> isn't a good system.  Eric Paris is working on inotify-type things as
> well.  It would be neat if you guys were to understand and review each
> other's work.  Please.

No problem, I will review patches if added to the copy. I'm not
subscsribed to linux-kernel@ so will miss them otherwise.

-- 
	Evgeniy Polyakov
