Return-Path: <linux-kernel-owner+w=401wt.eu-S1754407AbYGBSeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407AbYGBSeY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 14:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118AbYGBSeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 14:34:10 -0400
Received: from outbound-mail-141.bluehost.com ([67.222.38.31]:49617 "HELO
	outbound-mail-141.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751950AbYGBSeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 14:34:09 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull] PCI fixes for 2.6.26
Date: Wed, 2 Jul 2008 11:34:06 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>
References: <200807011004.47487.jbarnes@virtuousgeek.org>
In-Reply-To: <200807011004.47487.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807021134.07010.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 01, 2008 10:04 am Jesse Barnes wrote:
> I'll stop making predictions about whether this is the last pull request
> for 2.6.26 or not, but it is an important one.  It turns out that we've had
> a trivial DoS on machines containing PCI devices with bad VPDs.  We're
> entertaining a few options for a scalable, long term fix, but in the
> meantime, restricting access to the sysfs VPD file seems prudent.  I've
> included the patch in lieu of a diffstat since it's so small.

Ok, doesn't look like you've pulled yet, so I queued up a couple more crash
fixes (shortlog & diffstat include previous stuff as well).

Alex Chiang (1):
      PCI: acpiphp: cleanup notify handler on all root bridges

Ben Hutchings (1):
      PCI: Restrict VPD read permission to root

Benjamin Li (1):
      PCI: Limit VPD read/write lengths for Broadcom 5706, 5708, 5709 rev.

 drivers/pci/access.c               |   14 +++---------
 drivers/pci/hotplug/acpiphp_glue.c |   17 ++++++++++++--
 drivers/pci/pci-sysfs.c            |    4 +--
 drivers/pci/pci.h                  |    2 -
 drivers/pci/quirks.c               |   42 +++++++++++++++++++++++++++++++++++++
 5 files changed, 63 insertions(+), 16 deletions(-)

Thanks,
Jesse
