Return-Path: <linux-kernel-owner+w=401wt.eu-S1755848AbZGAL2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848AbZGAL2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 07:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311AbZGAL2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 07:28:10 -0400
Received: from carryall.technologeek.org ([62.4.18.94]:36677 "EHLO
	sonic.technologeek.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750812AbZGAL2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 07:28:10 -0400
X-Greylist: delayed 314 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Jul 2009 07:28:09 EDT
From: Julien BLACHE <jb@jblache.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, felixb@sgi.com
Subject: Re: [patch 000/108] 2.6.30-stable review
References: <20090701002838.GA7100@kroah.com>
Date: Wed, 01 Jul 2009 13:22:57 +0200
In-Reply-To: <20090701002838.GA7100@kroah.com> (Greg KH's message of "Tue, 30
	Jun 2009 17:28:38 -0700")
Message-ID: <87tz1wd4vi.fsf@sonic.technologeek.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.22 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> wrote:

Hi,

>  fs/Kconfig                                |   14 ++--
>  fs/cifs/file.c                            |   10 +-
>  fs/eventpoll.c                            |   21 +++--
>  fs/fs-writeback.c                         |    2 -
>  fs/jfs/jfs_extent.c                       |    1 +
>  fs/ocfs2/super.c                          |   32 +++++----
>  fs/ramfs/inode.c                          |    9 ++-

There is a memory leak in XFS in 2.6.30 that was fixed in commit
7747a0b0af5976ba3828796b4f7a7adc3bb76dbd (xfs: fix freeing memory in
xfs_getbmap()).

Felix wrote it was a candidate for stable (obviously!) but it's not on
the list you posted. Care to include it?

Thanks,

JB.

-- 
Julien BLACHE                                   <http://www.jblache.org> 
<jb@jblache.org>                                  GPG KeyID 0xF5D65169
