Return-Path: <linux-kernel-owner+w=401wt.eu-S1753547AbZFFUcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbZFFUcx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 16:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbZFFUcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 16:32:46 -0400
Received: from outbound-mail-147.bluehost.com ([67.222.38.37]:60546 "HELO
	outbound-mail-147.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751845AbZFFUcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 16:32:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=S6TBsLuj2Fuf9mtFp5SKioYwu2ifl+9V4wOpufzQveDNEM0P7WVCpar96Wd1yATOv6rbIecqngZXXQw5qtrH0JyFNsDuaUAD5HEsUI2NO1KUiItdLGz41oItcW5hBoFE;
Date: Sat, 6 Jun 2009 13:32:43 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] PCI fixes
Message-ID: <20090606133243.5ed92679@jbarnes-x200>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple more fixes; hopefully there's still time.  The device class
fix is an especially important regression fix.


The following changes since commit
9fa7eb283c5cdc2b0f4a8cfe6387ed82e5e9a3d3: Linus Torvalds (1):
        Linux 2.6.30-rc8

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 for-linus

Yinghai Lu (1):
      x86/pci: fix mmconfig detection with 32bit near 4g

Yu Zhao (1):
      PCI: use fixed-up device class when configuring device

 arch/x86/pci/mmconfig-shared.c |    6 +++---
 drivers/pci/probe.c            |    2 ++
 2 files changed, 5 insertions(+), 3 deletions(-)
