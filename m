Return-Path: <linux-kernel-owner+w=401wt.eu-S1754563AbYHYRHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbYHYRHh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 13:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbYHYRH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 13:07:28 -0400
Received: from outbound-mail-31.bluehost.com ([69.89.18.151]:41016 "HELO
	outbound-mail-31.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753506AbYHYRH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 13:07:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=Igk4jr9j9clpxhMyiq6EXmALXYl1BIy3Fv5tTSNf7zz3P2H0fFFycwm1HCxkthtK7nUP3GQSKZLosFPX98wMzWejzEsMMc29ltQCyhsO6tpAYAGb6Moqq6RE5DZLB2to;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] PCI fixes
Date: Mon, 25 Aug 2008 10:07:23 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808251007.23678.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull my for-linus branch:
git pull git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git for-linus

Just a few fixes to regressions we found this time around.  We're still
working on making the slot name stuff better, but the fixes from Alex here
will be compatible with anything we do later (mainly we want to avoid
creating entries for slots that aren't really hot pluggable anyway, which
will just mean Alex's conflict resolution code won't be needed as often).

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center

Alex Chiang (2):
      PCI: pciehp: Rename duplicate slot name N as N-1, N-2, N-M...
      PCI: shpchp: Rename duplicate slot name N as N-1, N-2, N-M...

Greg Kroah-Hartman (1):
      PCI: fix reference leak in pci_get_dev_by_id()

 drivers/pci/hotplug/pciehp.h      |    1 -
 drivers/pci/hotplug/pciehp_core.c |   21 ++++++++++++++-------
 drivers/pci/hotplug/pciehp_hpc.c  |   11 +----------
 drivers/pci/hotplug/shpchp_core.c |   34 +++++++++++++++-------------------
 drivers/pci/search.c              |    2 ++
 5 files changed, 32 insertions(+), 37 deletions(-)

