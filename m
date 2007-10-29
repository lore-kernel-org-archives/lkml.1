Return-Path: <linux-kernel-owner+w=401wt.eu-S1759215AbXJ2PYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759215AbXJ2PYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 11:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbXJ2PYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 11:24:40 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38152 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752608AbXJ2PYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 11:24:39 -0400
Date: Mon, 29 Oct 2007 16:24:47 +0100
From: Adrian Bunk <bunk@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] fs/afs/vlocation.c: fix off-by-one
Message-ID: <20071029152447.GP7227@stusta.de>
References: <20071027141957.GY30533@stusta.de> <3357.1193662826@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3357.1193662826@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007 at 01:00:26PM +0000, David Howells wrote:
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > This patch fixes an off-by-one error spotted by the Coverity checker.
> 
> NAK.
> 
> Why do you assume it's a NUL-terminated string?  It's not.  It's a fixed
> length character array that gets padded out with NULs.
> 
> Look 9 lines further down in the file from the change you made.  You'll notice
> it is using memcmp() not strcmp().

Check the last line of the patch I sent:
  if (vl->vldb.name[namesz] != '\0')

> David

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

