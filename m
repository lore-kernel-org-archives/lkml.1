Return-Path: <linux-kernel-owner+w=401wt.eu-S932690AbXEGK4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932690AbXEGK4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 06:56:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932664AbXEGK4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 06:56:09 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:40445 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932659AbXEGK4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 06:56:07 -0400
Date: Mon, 7 May 2007 12:56:07 +0200
From: Adrian Bunk <bunk@stusta.de>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, trond.myklebust@fys.uio.no,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [-mm patch] fix fs/nfs/nfsroot.c compile error
Message-ID: <20070507105607.GB4226@stusta.de>
References: <20070505164422.GD8975@stusta.de> <20070505014955.8f3990b5.akpm@linux-foundation.org> <15958.1178534871@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <15958.1178534871@redhat.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2007 at 11:47:51AM +0100, David Howells wrote:
> Adrian Bunk <bunk@stusta.de> wrote:
> 
> > match_table_t was made "const" and gcc doesn't like "const __initdata":
> 
> Hmmm...  My gcc seems quite happy with it.  What gcc are you using?

4.1

> Shouldn't __initdata override const?
> 
> > BTW: Why is this change to include/linux/parser.h in the net tree?
> 
> Because DaveM picked it up as part of my AFS patches, I guess.

It might make sense, but it doesn't seem to be in any way AFS specific.

> David

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

