Return-Path: <linux-kernel-owner+w=401wt.eu-S1030722AbXCFXnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030722AbXCFXnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 18:43:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030719AbXCFXnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 18:43:50 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:51759 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030724AbXCFXnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 18:43:49 -0500
Date: Wed, 7 Mar 2007 00:43:50 +0100
From: Adrian Bunk <bunk@stusta.de>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] fix the ROMFS_* dependencies
Message-ID: <20070306234349.GY3441@stusta.de>
References: <20070305014951.GD3441@stusta.de> <20070304152506.GC3441@stusta.de> <20070304041111.1d2774e7.akpm@linux-foundation.org> <20070302030026.5eef0c92.akpm@linux-foundation.org> <20070302030405.22f78999.akpm@linux-foundation.org> <45EAB46F.1030709@gmail.com> <14778.1173021069@redhat.com> <15200.1173022514@redhat.com> <14518.1173101815@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <14518.1173101815@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2007 at 01:36:55PM +0000, David Howells wrote:
> Adrian Bunk <bunk@stusta.de> wrote:
> 
> > OK, what about the patch below?
> 
> How many goats did you have to sacrifice to get that to work?

I'd say it was quite straightforward.  :-)

> I like it with
> just one very minor niggle: if CONFIG_BLOCK=y, CONFIG_MTD=y, CONFIG_ROMFS_FS=y
> CONFIG_EMBEDDED=y and CONFIG_ROMFS_ON_BLOCK=y then the CONFIG_ROMFS_ON_BLOCK
> configuration item disappears and reappears depending on the state of
> CONFIG_ROMFS_ON_MTD.  But, as I said, it's a very minor niggle.
>...

I've also seen this, but I didn't find any way to solve this, and 
cosmetical issues only visible with CONFIG_EMBEDDED=y are nothing I'm 
that much worried about.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

