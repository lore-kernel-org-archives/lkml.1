Return-Path: <linux-kernel-owner+w=401wt.eu-S1754310AbZCKSfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310AbZCKSfs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 14:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbZCKSfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 14:35:39 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:43147 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbZCKSfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 14:35:39 -0400
Date: Wed, 11 Mar 2009 19:37:35 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Kyle McMartin <kyle@infradead.org>
Cc: linux-kernel@vger.kernel.org, jakub@redhat.com,
       linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] scripts/unifdef.c: rename getline symbol to something else
Message-ID: <20090311183735.GA2832@uranus.ravnborg.org>
References: <20090311161733.GE5448@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090311161733.GE5448@bombadil.infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 12:17:33PM -0400, Kyle McMartin wrote:
> From: Kyle McMartin <kyle@redhat.com>
> 
> Rawhide builds are currently failing to build unifdef.c, as the next
> version of glibc changes the default _POSIX_C_SOURCE level, which
> exposes getline() from <stdio.h>
> 
> scripts/unifdef.c:209: error: conflicting types for 'getline'
> /usr/include/stdio.h:653: note: previous declaration of 'getline' was
> here
> make[2]: *** [scripts/unifdef] Error 1
> make[1]: *** [__headers] Error 2
> make: *** [vmlinux] Error 2
> 
> Rename the symbol in unifdef.c to parseline to avoid this conflicting
> declaration.

I have a similar patch queued in kbuild-fixes.git.

	Sam
