Return-Path: <linux-kernel-owner+w=401wt.eu-S1754667AbXKFO0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbXKFO0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 09:26:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbXKFO0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 09:26:18 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:51560 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbXKFO0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 09:26:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=CaNdkzoxAIzeFzNT/R4Op6+obv5jlWyCgNHubUtR5dT2Lu0BeQuUINwCQPiTiAwnDj7sIVJ++7HVzcI5RkhS2mTCtoiWeEEPpzIcb0yRhHM0F29ZdtFGvgj9YOOk/rj3Eg91lpoE7o4C6jmCqS5TwNGpyPdV3O7Z2j5gDAFINZ4=
Message-ID: <a4e6962a0711060626x46e2355ak92f04f555013edf1@mail.gmail.com>
Date: Tue, 6 Nov 2007 08:26:17 -0600
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: torvalds@osdl.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "V9FS Developers" <v9fs-developer@lists.sourceforge.net>
Subject: [GIT PULL] 9p: 2.6.24-rc1 patches
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,
   Please pull the following bug-fixes for v9fs.

The following changes since commit 2655e2cee2d77459fcb7e10228259e4ee0328697:
  Alan Cox (1):
        ata_piix: Add additional PCI identifier for 40 wire short cable

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git for-linus

Latchesar Ionkov (4):
      9p: fix memory leak in v9fs_get_sb
      9p: use copy of the options value instead of original
      9p: return NULL when trans not found
      9p: add missing end-of-options record for trans_fd

 fs/9p/v9fs.c      |    6 ++++--
 fs/9p/vfs_super.c |    3 +++
 net/9p/mod.c      |    4 ++--
 net/9p/trans_fd.c |    3 ++-
 4 files changed, 11 insertions(+), 5 deletions(-)

   Thanks,
         -eric
