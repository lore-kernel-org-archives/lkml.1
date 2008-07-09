Return-Path: <linux-kernel-owner+w=401wt.eu-S1754783AbYGIGtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbYGIGtj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 02:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751697AbYGIGt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 02:49:29 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:42657 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbYGIGt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 02:49:28 -0400
To: arjan@infradead.org
CC: miklos@szeredi.hu, hch@infradead.org, miklos@szeredi.hu, tytso@mit.edu,
       pavel@suse.cz, t-sato@yk.jp.nec.com, akpm@linux-foundation.org,
       viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
       dm-devel@redhat.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, axboe@kernel.dk,
       mtk.manpages@googlemail.com
In-reply-to: <20080708234120.5072111f@infradead.org> (message from Arjan van
	de Ven on Tue, 8 Jul 2008 23:41:20 -0700)
Subject: Re: [PATCH 3/3] Add timeout feature
References: <20080630212450t-sato@mail.jp.nec.com>
	<20080701081026.GB16691@infradead.org>
	<20080707110730.GG5643@ucw.cz>
	<20080708231026.GP11558@disturbed>
	<20080708232031.GE18195@elf.ucw.cz>
	<20080709005254.GQ11558@disturbed>
	<20080709010922.GE9957@mit.edu>
	<E1KGSvZ-0006dB-53@pomaz-ex.szeredi.hu>
	<20080709061621.GA5260@infradead.org>
	<E1KGT4q-0006fD-Jb@pomaz-ex.szeredi.hu> <20080708234120.5072111f@infradead.org>
Message-Id: <E1KGTTm-0006ke-Jh@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 09 Jul 2008 08:48:42 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jul 2008, Arjan van de Ven wrote:
> nah he needs to do
> 
> make_snapshot ; backup-command ; unref_snapshot.
> 
> freezing isn't the right solution for the backup problem ;)

Confused, what's freezing _is_ for then?  Patch description says:

  Currently, ext3 in mainline Linux doesn't have the freeze feature which
  suspends write requests.  So, we cannot take a backup which keeps
  the filesystem's consistency with the storage device's features
  (snapshot and replication) while it is mounted.
  In many case, a commercial filesystem (e.g. VxFS) has
  the freeze feature and it would be used to get the consistent backup.
  If Linux's standard filesytem ext3 has the freeze feature, we can do it
  without a commercial filesystem.

Miklos
