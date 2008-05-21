Return-Path: <linux-kernel-owner+w=401wt.eu-S937084AbYEUTp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937084AbYEUTp4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 15:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936907AbYEUTpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 15:45:33 -0400
Received: from gv-out-0910.google.com ([216.239.58.187]:21182 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936915AbYEUTpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 15:45:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=gBhFoBjTD+3C6B4DNHL69C19Mf0tD0YLnsv5Sl8TeZUEGG8BQZGRNsQOnoWgBZMCUj0SSDt7oL125D10un5x9srLlG8XV8dpNetio+dYC86YuCLUt3P4dWiYCvqwNjYCJ7BasIiaHVRKYLuoriMNmTnvWx7i7iOVMaoL3lkQp7U=
Date: Wed, 21 May 2008 23:45:22 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
       davem@davemloft.net
Subject: Re: CFD: linux-wanking@vger.kernel.org (was [PATCH] Standard
	indentation of arguments)
Message-ID: <20080521194522.GA13916@cvg>
References: <12113495282137-git-send-email-kongjianjun@gmail.com> <20080521083413.GM28946@ZenIV.linux.org.uk> <20080521015037.add0b78e.akpm@linux-foundation.org> <20080521103206.GA24545@infradead.org> <20080521120939.GF8581@mit.edu> <20080521104644.5b6f4e63.akpm@linux-foundation.org> <20080521185725.GD6932@cvg> <20080521123355.b34f07ad.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080521123355.b34f07ad.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Randy Dunlap - Wed, May 21, 2008 at 12:33:55PM -0700]
| On Wed, 21 May 2008 22:57:25 +0400 Cyrill Gorcunov wrote:
| 
| > [Andrew Morton - Wed, May 21, 2008 at 10:46:44AM -0700]
| > | On Wed, 21 May 2008 08:09:39 -0400 Theodore Tso <tytso@mit.edu> wrote:
| > | 
| > | > On Wed, May 21, 2008 at 06:32:06AM -0400, Christoph Hellwig wrote:
| > | > > On Wed, May 21, 2008 at 01:50:37AM -0700, Andrew Morton wrote:
| > | > > > Oh, what a marvellous way to encourage new contributors that was. Thank
| > | > > > you so much.
| > | > > > 
| > | > > > For the record: Al speaks only for himself and a lack of expressed
| > | > > > disagrement from others should not be taken as agreement.
| > | > > 
| > | > > But I'd like to second the opinion.  This is getting a little too far.
| > | > > We should rather try to at least enforce very basic standards a lot of
| > | > > the crap shoved in doesn't follow instead of wanking around about exact
| > | > > placement of whitespaces.
| > | > 
| > | > The real question is whether people who are wanking about whitespace
| > | > and spelling fixes in comments will graduate to writing real, useful
| > | > patches.  If they won't, there's no point to encouraging them.
| > | > 
| > | 
| > | Guys, get a clue.  It doesn't matter what that person did.  It is the
| > | effect upon *all* other potential developers which is so damaging here.
| > | Not upon this individual.
| > | 
| > 
| > Btw, we have CodingStyle, SubmittingPatches and other, but why don't
| > we have something like KernelNewbieGuide? Don't get me wrong, but
| > there could be written all rules about - what is good to do, what is bad.
| > So a newbiew who wants to be usefull for kernel could read it and decide
| > what should be done. /Don't beat me ;) / And of course I know about
| > kernelnewbie.org but this (even quite short) document could help I think.
| 
| I did a talk on Linux "social engineering" at {OSCON, IEEE NW something,
| and SCALE}.  All about what (not) to do, how to do it, etc.
| Slides for it are available in http://www.xenotime.net/linux/mentor/ .
| 
| 
| ---
| ~Randy
|

Anrew, Randy, you just wrote KernelNewbiesGuide I think ;) There are
lot of internet sites which could help with what-to-do, and linux-mm.org
and kernel.bugzilla.org and more BUT what I've tried to say is that we
really have such document inside kernel tree (it could be really short)
like:

Which patches are not good for sending to LKML
----------------------------------------------

 - Plain whitespace cleanup

Some rules just *known* only if you have an experience in LKML mailing
but if someone is sending _first_ patch he ever made he just doesn't know
that. That is all. So we need not a link to some inet resource BUT written
in file inside of kernel tree. But that is just my (personal) opinion.

		- Cyrill -
