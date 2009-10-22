Return-Path: <linux-kernel-owner+w=401wt.eu-S1753257AbZJVGNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbZJVGNm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 02:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbZJVGNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 02:13:42 -0400
Received: from ozlabs.org ([203.10.76.45]:58183 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263AbZJVGNl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 02:13:41 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PULL] virtio fixes
Date: Thu, 22 Oct 2009 16:43:44 +1030
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <200910191301.24726.rusty@rustcorp.com.au> <alpine.LFD.2.00.0910220831090.9771@eeepc.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0910220831090.9771@eeepc.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200910221643.44411.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Oct 2009 10:01:43 am Linus Torvalds wrote:
> 
> On Mon, 19 Oct 2009, Rusty Russell wrote:
> > 
> >   ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master
> 
> "Already up-to-date.".
> 
> Forgot to push?

Oops, overzealous master.kernel.org space reclamation from me :

This time for sure!
Rusty/

The following changes since commit 2fdc246aaf9a7fa088451ad2a72e9119b5f7f029:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../bp/bp

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master

Christian Borntraeger (1):
      virtio: let header files include virtio_ids.h

Christoph Hellwig (1):
      virtio_blk: revert QUEUE_FLAG_VIRT addition

Rusty Russell (1):
      virtio_blk: Revert serial number support

Uwe Kleine-König (2):
      move virtballoon_remove to .devexit.text
      move virtrng_remove to .devexit.text

 Documentation/lguest/lguest.c       |    1 -
 drivers/block/virtio_blk.c          |   39 ++--------------------------------
 drivers/char/hw_random/virtio-rng.c |    3 +-
 drivers/char/virtio_console.c       |    1 -
 drivers/net/virtio_net.c            |    1 -
 drivers/virtio/virtio_balloon.c     |    3 +-
 include/linux/Kbuild                |    1 +
 include/linux/virtio_9p.h           |    1 +
 include/linux/virtio_balloon.h      |    1 +
 include/linux/virtio_blk.h          |    5 +---
 include/linux/virtio_console.h      |    1 +
 include/linux/virtio_net.h          |    1 +
 include/linux/virtio_rng.h          |    1 +
 net/9p/trans_virtio.c               |    1 -
 14 files changed, 12 insertions(+), 48 deletions(-)
