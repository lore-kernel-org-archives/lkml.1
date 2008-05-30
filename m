Return-Path: <linux-kernel-owner+w=401wt.eu-S1753293AbYE3QyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbYE3QyW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 12:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752263AbYE3QyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 12:54:10 -0400
Received: from outbound-mail-155.bluehost.com ([67.222.39.35]:60396 "HELO
	outbound-mail-155.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752147AbYE3QyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 12:54:09 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [git pull] last minute PCI fixes
Date: Fri, 30 May 2008 09:54:01 -0700
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805300954.01161.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull a last minute fix intended for 2.6.26:
git pull git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git for-linus

BenH found a bug that broke ABI in the POWER6 PCI hotplug code, so we needed
to get the fix upstream asap.

Thanks,
Jesse

Benjamin Herrenschmidt (1):
      PCI: fix rpadlpar pci hotplug driver sysfs usage

 rpadlpar_sysfs.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)
