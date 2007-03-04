Return-Path: <linux-kernel-owner+w=401wt.eu-S932936AbXCDPh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932936AbXCDPh5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 10:37:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932955AbXCDPh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 10:37:57 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932936AbXCDPh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 10:37:56 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070304152506.GC3441@stusta.de> 
References: <20070304152506.GC3441@stusta.de>  <20070304041111.1d2774e7.akpm@linux-foundation.org> <20070302030026.5eef0c92.akpm@linux-foundation.org> <20070302030405.22f78999.akpm@linux-foundation.org> <45EAB46F.1030709@gmail.com> <14778.1173021069@redhat.com> 
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [Re: 2.6.21-rc2-mm1] #error no ROMFS backing store interface configured 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Sun, 04 Mar 2007 15:35:14 +0000
Message-ID: <15200.1173022514@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@stusta.de> wrote:

> Is
> 
> CONFIG_BLOCK=y
> CONFIG_ROMFS_FS=y
> CONFIG_ROMFS_ON_BLOCK=n
> CONFIG_ROMFS_ON_MTD=y
> 
> a reasonable configuration that should be supported, or can we turn 
> CONFIG_ROMFS_ON_BLOCK always on if CONFIG_BLOCK=y?

Hmmm...  I don't really know the answer to that, apart from it depends.  On a
non-embedded device, it's entirely reasonable, I think, to turn
CONFIG_ROMFS_ON_BLOCK on if CONFIG_BLOCK is on, no questions asked.  However,
on an embedded device you might want the extra option.

David
