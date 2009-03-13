Return-Path: <linux-kernel-owner+w=401wt.eu-S1757653AbZCMFu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653AbZCMFu2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 01:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751656AbZCMFuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 01:50:16 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:49456 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbZCMFuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 01:50:15 -0400
Date: Fri, 13 Mar 2009 06:52:09 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kyle McMartin <kyle@infradead.org>, linux-kernel@vger.kernel.org,
       jakub@redhat.com, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] scripts/unifdef.c: rename getline symbol to something else
Message-ID: <20090313055209.GA18111@uranus.ravnborg.org>
References: <20090311161733.GE5448@bombadil.infradead.org> <20090311183735.GA2832@uranus.ravnborg.org> <20090311185942.GA11433@bombadil.infradead.org> <20090311235651.3c3fba2a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090311235651.3c3fba2a.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 11:56:51PM -0700, Andrew Morton wrote:
> On Wed, 11 Mar 2009 14:59:42 -0400 Kyle McMartin <kyle@infradead.org> wrote:
> 
> > On Wed, Mar 11, 2009 at 07:37:35PM +0100, Sam Ravnborg wrote:
> > > > Rawhide builds are currently failing to build unifdef.c, as the next
> > > > version of glibc changes the default _POSIX_C_SOURCE level, which
> > > > exposes getline() from <stdio.h>
> > > > 
> > > > scripts/unifdef.c:209: error: conflicting types for 'getline'
> > > > /usr/include/stdio.h:653: note: previous declaration of 'getline' was
> > > > here
> > > > make[2]: *** [scripts/unifdef] Error 1
> > > > make[1]: *** [__headers] Error 2
> > > > make: *** [vmlinux] Error 2
> > > > 
> > > > Rename the symbol in unifdef.c to parseline to avoid this conflicting
> > > > declaration.
> > > 
> > > I have a similar patch queued in kbuild-fixes.git.
> > > 
> > 
> > Great, thanks. Is this going to go into the next -rc?
> > 
> 
> I was going to put it into 2.6.29 but Sam stole it :)
Bad boy.
The patch is included in -rc8 so everyone is happy again.

	Sam
