Return-Path: <linux-kernel-owner+w=401wt.eu-S933809AbZIDSGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933809AbZIDSGL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 14:06:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757190AbZIDSGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 14:06:08 -0400
Received: from outbound-mail-132.bluehost.com ([67.222.39.22]:45813 "HELO
	outbound-mail-132.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757187AbZIDSGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 14:06:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=FJYhXONmTqs9q6E8NqL37YeGS0RzjBJHoj4IZv/lvZTMG2WkFOJ/RKH1s+90iE81xmO9iZvc6OIenRmMDA3lCTnyoGN68jYhCirhRriSF2SHCBzpMlegjLTmINjvLSFk;
Date: Fri, 4 Sep 2009 11:05:42 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] PCI fix
Message-ID: <20090904110542.0262a067@jbarnes-g45>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit adda766193ea1cf3137484a9521972d080d0b7af:
  Linus Torvalds (1):
        Merge branch 'release' of git://git.kernel.org/.../lenb/linux-acpi-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 for-linus

One more last minute fix from Chris.  Without this, devices supporting SR-IOV
have much inflated (and unnecessary) alignment requirements, which can lead to
resource allocation failures.

Chris Wright (1):
      PCI SR-IOV: correct broken resource alignment calculations

 drivers/pci/iov.c       |   23 +++++++++++++++++++++++
 drivers/pci/pci.h       |   13 +++++++++++++
 drivers/pci/setup-bus.c |    4 ++--
 drivers/pci/setup-res.c |    8 ++++----
 4 files changed, 42 insertions(+), 6 deletions(-)

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
