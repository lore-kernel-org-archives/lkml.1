Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbZCLHAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbZCLHAT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 03:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbZCLHAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 03:00:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42908 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750949AbZCLHAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 03:00:03 -0400
Date: Wed, 11 Mar 2009 23:56:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kyle McMartin <kyle@infradead.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       jakub@redhat.com, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] scripts/unifdef.c: rename getline symbol to something
 else
Message-Id: <20090311235651.3c3fba2a.akpm@linux-foundation.org>
In-Reply-To: <20090311185942.GA11433@bombadil.infradead.org>
References: <20090311161733.GE5448@bombadil.infradead.org>
	<20090311183735.GA2832@uranus.ravnborg.org>
	<20090311185942.GA11433@bombadil.infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Mar 2009 14:59:42 -0400 Kyle McMartin <kyle@infradead.org> wrote:

> On Wed, Mar 11, 2009 at 07:37:35PM +0100, Sam Ravnborg wrote:
> > > Rawhide builds are currently failing to build unifdef.c, as the next
> > > version of glibc changes the default _POSIX_C_SOURCE level, which
> > > exposes getline() from <stdio.h>
> > > 
> > > scripts/unifdef.c:209: error: conflicting types for 'getline'
> > > /usr/include/stdio.h:653: note: previous declaration of 'getline' was
> > > here
> > > make[2]: *** [scripts/unifdef] Error 1
> > > make[1]: *** [__headers] Error 2
> > > make: *** [vmlinux] Error 2
> > > 
> > > Rename the symbol in unifdef.c to parseline to avoid this conflicting
> > > declaration.
> > 
> > I have a similar patch queued in kbuild-fixes.git.
> > 
> 
> Great, thanks. Is this going to go into the next -rc?
> 

I was going to put it into 2.6.29 but Sam stole it :)
