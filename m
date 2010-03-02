Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab0CBP1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 10:27:01 -0500
Received: from mail-qy0-f179.google.com ([209.85.221.179]:41996 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab0CBP07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 10:26:59 -0500
Date: Tue, 2 Mar 2010 07:26:55 -0800
From: "Shawn O. Pearce" <spearce@spearce.org>
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, git <git@vger.kernel.org>
Subject: Re: Google Gerrit
Message-ID: <20100302152655.GC28997@spearce.org>
References: <c1fb08351003020610q25b85b60hf9362aabc4b0126f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1fb08351003020610q25b85b60hf9362aabc4b0126f@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anca Emanuel <anca.emanuel@gmail.com> wrote:
> Hi, what do you think about Google Gerrit ? http://code.google.com/p/gerrit/
> 
> see it in action here: http://review.source.android.com

For kernel or at least C-ish folk... a kernel patch under development
might be more relevant to point to.  E.g.:

https://review.source.android.com/13610
 
> quote:
> "Gerrit is a web based code review system, facilitating online code
> reviews for projects using the Git version control system.
> Gerrit makes reviews easier by showing changes in a side-by-side
> display, and allowing inline comments to be added by any reviewer.
> Gerrit simplifies Git based project maintainership by permitting any
> authorized user to submit changes to the master Git repository, rather
> than requiring all approved changes to be merged in by hand by the
> project maintainer. This functionality enables a more centralized
> usage of Git."

I hate that description.  I keep meaning to overhaul the project
landing page with screenshots and try to describe the feature set
better, but I've been too busy with coding.
 
> git needs an friendly UI, web based is the future.

We have a number of UIs for Git... some more user friendly to
certain classes of users than others.  But I'm not sold that a
web based interface is the future.

Sometimes a web UI can be very convient to work with.  Sometimes, the
existing mailing list review infrastructure works very well.  What I
love most about Git is how much choice we really have as users.
 
> Maybe an integration with Wave.

Maybe.  But I'm not actively pursuing that right now.  If someone
else develops a Gitty bot for Wave, that would be cool.

Actually... my goal over the next couple of months here is to
make Gerrit Code Review no longer dependent on a web UI, or on a
backend SQL database.  I'm going to shift all of the data storage
into Git meta branches, and the code annotations into Git notes.
Which will make it very friendly to build other tools like an Emacs
plugin that can interoperate based solely on raw Git commands and
formats, without ever touching the existing Java or web UI.

I think the biggest challenge I have is I need a good inverted
search index, and Git has no standard for that.  I'm tempted to
use Apache Lucene[1] because in Java its simple to work with,
but their C port has been dangling in the wind for a long time.

[1] http://lucene.apache.org/

-- 
Shawn.
