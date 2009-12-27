Return-Path: <linux-kernel-owner+w=401wt.eu-S1751463AbZL0WwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463AbZL0WwU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 17:52:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbZL0WwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 17:52:19 -0500
Received: from THUNK.ORG ([69.25.196.29]:41348 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbZL0WwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 17:52:19 -0500
Date: Sun, 27 Dec 2009 17:52:16 -0500
From: tytso@mit.edu
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       dmitry.torokhov@gmail.com
Subject: Re: 2.6.33-rc1: kernel BUG at fs/ext4/inode.c:1063 (sparc)
Message-ID: <20091227225216.GB4429@thunk.org>
Mail-Followup-To: tytso@mit.edu,
	Alexander Beregalov <a.beregalov@gmail.com>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
	dmitry.torokhov@gmail.com
References: <a4423d670912241428n6917d2adsad887548612cf8ce@mail.gmail.com>
 <a4423d670912241449y2da43d5fi3e5a18c114b84178@mail.gmail.com>
 <87hbrfdylc.fsf@openvz.org>
 <a4423d670912251133u795338a4wd32d5cdef8c36c75@mail.gmail.com>
 <87eimir4yk.fsf@openvz.org>
 <a4423d670912271232y5bb928f7wb667ca71f1a93f8a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670912271232y5bb928f7wb667ca71f1a93f8a@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 27, 2009 at 11:32:25PM +0300, Alexander Beregalov wrote:
> >> I will try to crosscompile the kernel with Ted's patch on another host.
> 
> Here is output of 2.6.33-rc2 plus Ted's patch
> 
> EXT4-fs (sda1): inode #1387643: mdb_free (1) < mdb_claim (2) BUG

OK, can you give me the output of:

debugfs /dev/sda1
debugfs: stat <1387643>
debugfs: ncheck 1387643
debugfs: quit

Thanks!!

						- Ted
