Return-Path: <linux-kernel-owner+w=401wt.eu-S1756807AbYKETzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807AbYKETzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 14:55:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754599AbYKETzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 14:55:44 -0500
Received: from rv-out-0506.google.com ([209.85.198.238]:27180 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbYKETzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 14:55:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=uElyE5viQ+1Ku0gIJJrYdVrYSlUJ0Koy/u607ReW6GhH/N4wkiIPOpLGZXSY+fcd+Q
         Nn0V1EBrqj2hYcX/X/4AE0CYNr8SWUQqwn7sUCBHUXDg7ACXd/SLjYAVFcSO6/n8nINO
         oW1Jjdq19i9wFjDa8smZEtiZYXW1Cj5VXGAtE=
Message-ID: <a4e6962a0811051155y2c9a0f2p93772b69f7dd1bfa@mail.gmail.com>
Date: Wed, 5 Nov 2008 13:55:42 -0600
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "V9FS Developers" <v9fs-developer@lists.sourceforge.net>
Subject: [GIT PULL] 9p bug fixes for 2.6.28-rc3
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 75fa67706cce5272bcfc51ed646f2da21f3bdb6e:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/net-2.6

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git for-linus

Huang Weiyi (1):
      9p: rdma: remove duplicated #include

Randy Dunlap (1):
      net/9p: fix printk format warnings

Roel Kluin (1):
      unsigned fid->fid cannot be negative

Tom Tucker (4):
      9p: rdma: Set trans prior to requesting async connection ops
      9p: Make all client spin locks IRQ safe
      9p: Remove unneeded free of fcall for Flush
      p9: Fix leak of waitqueue in request allocation path

 net/9p/client.c     |   59 +++++++++++++++++++++++++++++---------------------
 net/9p/trans_rdma.c |    5 ++-
 2 files changed, 37 insertions(+), 27 deletions(-)

        Thanks,
             -eric
