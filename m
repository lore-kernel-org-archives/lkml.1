Return-Path: <linux-kernel-owner+w=401wt.eu-S1756477AbZETXbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477AbZETXbG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 19:31:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbZETXa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 19:30:56 -0400
Received: from outbound-mail-23.bluehost.com ([69.89.21.18]:35314 "HELO
	outbound-mail-23.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753651AbZETXa4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 19:30:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=BYD/6nEhUwy5c9WeUgTIoTrtJC3+DmlK/DktHNH6p6FMYawf9l+RDbe96g+DP3eNaPx27IqB4bcJ87sZ7BI0yoc4itF3bYNIx5p2fBfjGIgFAtKdj7gOF+gU34H/0O33;
Date: Wed, 20 May 2009 16:30:43 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: [git pull] drm fixes
Message-ID: <20090520163043.57121af1@jbarnes-g45>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple more fixes for .30.

The following changes since commit
279e677faa775ad16e75c32e1bf4a37f8158bc61: Linus Torvalds (1):
        Merge branch 'fixes-for-linus' of
git://git.monstr.eu/linux-2.6-microblaze

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/drm-2.6 for-linus

Benjamin Herrenschmidt (1):
      drm: Round size of SHM maps to PAGE_SIZE

Michel Dänzer (1):
      drm: Copy back ioctl data to userspace regardless of return code.

 drivers/gpu/drm/drm_bufs.c |    8 ++++++++
 drivers/gpu/drm/drm_drv.c  |    2 +-
 2 files changed, 9 insertions(+), 1 deletions(-)

-- 
Jesse Barnes, Intel Open Source Technology Center
