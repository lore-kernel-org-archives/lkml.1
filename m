Return-Path: <linux-kernel-owner+w=401wt.eu-S1755469AbZJBHnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbZJBHnt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 03:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbZJBHnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 03:43:49 -0400
Received: from adelie.canonical.com ([91.189.90.139]:35410 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446AbZJBHns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 03:43:48 -0400
Date: Fri, 2 Oct 2009 08:43:51 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] checkpatch: fix __attribute__ matching
Message-ID: <20091002074351.GK2957@shadowen.org>
References: <1253585691-10987-1-git-send-email-dwalker@fifo99.com>
 <1253585691-10987-2-git-send-email-dwalker@fifo99.com>
 <1253585691-10987-3-git-send-email-dwalker@fifo99.com>
 <1253585691-10987-4-git-send-email-dwalker@fifo99.com>
 <20090930174624.GF2957@shadowen.org>
 <1254407172.18167.96.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254407172.18167.96.camel@desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 01, 2009 at 07:26:12AM -0700, Daniel Walker wrote:
> On Wed, 2009-09-30 at 18:46 +0100, Andy Whitcroft wrote:
> 
> > The problem with the __attribute__ match is that it is impossible to
> > sensibly write as a regular-expression as it has nested round brackets
> > within it.  I do wonder why we care what is before the equals.  I
> > suspect that any assignment ='s followed by a newline, followed by a {
> > is wrong.  There are few places that a { is right on the next line.
> 
> Yeah, I was thinking about that also .. I though there might be some
> "= {" situation I wasn't thinking of tho.
> 
> > I'll try that one out and see if it fires any false positives.  Its
> > passing my tests here.
> > 
> > Could you see if the version at the url below works better for you:
> > 
> >   http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-testing
> 
> I'm wondering about your release cycle .. You seem to be selectively
> sending patches to Andrew ? Have you considered putting all your changes
> into Linux-Next for instance then just keep up with the merge-window
> cycle ? Either that or send everything to Andrew.. Either way, you would
> have all the changes getting tested, instead of something like above
> where is "testing" or a version number at an obscure url location..

Linux-next might also make sense, though generally I'd seen it as an
integration test bed to catch cross tree merge conflicts and I don't
generally have that issue.  There is a wrinkle that my checkpatch tree
is separate tree because it contains a large test suite and that really
isn't something we likely want in the kernel tree itself.  I will look
at generating some real linux based branches from my tree and pushing
those to g.k.o which would be suitable for pulling into -next.

I have been distracted lately getting up to speed in a new role and that
has impacted the regular flow of checkpatch stuff.  I am hoping to get
back to normal service there.

-apw
