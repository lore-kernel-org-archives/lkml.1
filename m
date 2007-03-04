Return-Path: <linux-kernel-owner+w=401wt.eu-S932817AbXCDPZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932817AbXCDPZJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 10:25:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932873AbXCDPZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 10:25:09 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:49488 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932817AbXCDPZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 10:25:08 -0500
Date: Sun, 4 Mar 2007 16:25:06 +0100
From: Adrian Bunk <bunk@stusta.de>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [Re: 2.6.21-rc2-mm1] #error no ROMFS backing store interface configured
Message-ID: <20070304152506.GC3441@stusta.de>
References: <20070304041111.1d2774e7.akpm@linux-foundation.org> <20070302030026.5eef0c92.akpm@linux-foundation.org> <20070302030405.22f78999.akpm@linux-foundation.org> <45EAB46F.1030709@gmail.com> <14778.1173021069@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <14778.1173021069@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 04, 2007 at 03:11:09PM +0000, David Howells wrote:
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > So we require that one of these be enabled if ROMFS.
> 
> At least one, yes.  Both can be enabled.  I don't know how to do it though.

How to solve it depends on the intended semantics.

Is

CONFIG_BLOCK=y
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_ON_BLOCK=n
CONFIG_ROMFS_ON_MTD=y

a reasonable configuration that should be supported, or can we turn 
CONFIG_ROMFS_ON_BLOCK always on if CONFIG_BLOCK=y?

> David

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

