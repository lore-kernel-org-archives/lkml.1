Return-Path: <linux-kernel-owner+w=401wt.eu-S1753356AbZCKS74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbZCKS74 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 14:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbZCKS7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 14:59:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46538 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbZCKS7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 14:59:46 -0400
Date: Wed, 11 Mar 2009 14:59:42 -0400
From: Kyle McMartin <kyle@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Kyle McMartin <kyle@infradead.org>, linux-kernel@vger.kernel.org,
       jakub@redhat.com, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] scripts/unifdef.c: rename getline symbol to something
	else
Message-ID: <20090311185942.GA11433@bombadil.infradead.org>
References: <20090311161733.GE5448@bombadil.infradead.org> <20090311183735.GA2832@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090311183735.GA2832@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 07:37:35PM +0100, Sam Ravnborg wrote:
> > Rawhide builds are currently failing to build unifdef.c, as the next
> > version of glibc changes the default _POSIX_C_SOURCE level, which
> > exposes getline() from <stdio.h>
> > 
> > scripts/unifdef.c:209: error: conflicting types for 'getline'
> > /usr/include/stdio.h:653: note: previous declaration of 'getline' was
> > here
> > make[2]: *** [scripts/unifdef] Error 1
> > make[1]: *** [__headers] Error 2
> > make: *** [vmlinux] Error 2
> > 
> > Rename the symbol in unifdef.c to parseline to avoid this conflicting
> > declaration.
> 
> I have a similar patch queued in kbuild-fixes.git.
> 

Great, thanks. Is this going to go into the next -rc?

regards, Kyle
