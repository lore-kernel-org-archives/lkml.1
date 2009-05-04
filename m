Return-Path: <linux-kernel-owner+w=401wt.eu-S1758870AbZEDSAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758870AbZEDSAq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 14:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758492AbZEDSA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 14:00:29 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:42947 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758791AbZEDSA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 14:00:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Vd01JoS+Bf+3PUsoyABZy1iU7vq4WkCtlebn1uhcNgy343OKMoG//hZCyQBITGBf5F
         19zGi90c44nQIl+3wUTzCQr45ys7BXM+2nkwEGU/5Q8oF5WiVxSsL+WVmW90LKxGa2iP
         7Bv6jivwjNvxyReh+faI5p2Dz0djDku59xcfE=
MIME-Version: 1.0
Date: Mon, 4 May 2009 13:00:26 -0500
Message-ID: <a4e6962a0905041100m72ab4b01r4ac4c959aaab312f@mail.gmail.com>
Subject: [GIT PULL] v9fs bug fixes against 2.6.30-rc4
From: Eric Van Hensbergen <ericvh@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit b4348f32dae3cb6eb4bc21c7ed8f76c0b11e9d6a:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://oss.sgi.com/xfs/xfs

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git for-linus

Latchesar Ionkov (3):
      net/9p: set correct stat size when sending Twstat messages
      net/9p: return error when p9_client_stat fails
      net/9p: handle correctly interrupted 9P requests

 include/net/9p/client.h |    1 -
 net/9p/client.c         |  114 ++++++++++++++++++++++------------------------
 net/9p/trans_fd.c       |   14 ++++--
 net/9p/trans_rdma.c     |    1 +
 net/9p/trans_virtio.c   |    1 +
 5 files changed, 66 insertions(+), 65 deletions(-)

Thanks,
    eric
