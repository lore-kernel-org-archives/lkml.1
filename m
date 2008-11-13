Return-Path: <linux-kernel-owner+w=401wt.eu-S1754919AbYKMUu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbYKMUu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 15:50:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbYKMUuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 15:50:12 -0500
Received: from outbound-mail-33.bluehost.com ([69.89.18.153]:53160 "HELO
	outbound-mail-33.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751645AbYKMUuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 15:50:11 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=nMZq8H3b6PokTdnWUoI4Uzr914N6HbNOQMAs60WHKLuIgWelCW8N/6rAIfOKhr3nNrhn61fuUnvbczNpGcehGXJjAAOuXYFmpe5s2P+hsEOMPExGlm2DV7y7n1F7tbfs;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] PCI fixes
Date: Thu, 13 Nov 2008 12:50:07 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.26.6-79.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, "linux-pci" <linux-pci@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811131250.07677.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull my for-linus branch:
git pull git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git for-linus

Just one more fix for 2.6.28 is queued up so far, but it does allow booting
on certain platforms, so it's an important one.

Thanks,
Jesse

Kenji Kaneshige (1):
      PCI: ignore bit0 of _OSC return code

 drivers/pci/pci-acpi.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

