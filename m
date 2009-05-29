Return-Path: <linux-kernel-owner+w=401wt.eu-S1759418AbZE2Sa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759418AbZE2Sa1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 14:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbZE2SaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 14:30:20 -0400
Received: from outbound-mail-304.bluehost.com ([67.222.53.250]:53293 "HELO
	outbound-mail-304.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752915AbZE2SaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 14:30:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=U0LQPhqyUFZhPrrOCbSrnF8iVqbuctUrf1mOkJRu/ivHMI5YkYIaXjKOJCZvsu+fJWHEAtigMrObYYycIHsizNMXo6w7vpKgleVXNCvzcDOrj8HSr8Q6EWnyuZBjU6yq;
Date: Fri, 29 May 2009 11:30:10 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] PCI fix
Message-ID: <20090529113010.07bfd717@jbarnes-x200>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 80.67.104.110 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please consider pulling the PCI fixes from
git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 for-linus

Includes an oops fix for the acpiphp module when both physical and
logical hotplug are used.  There should be another one on its way from
Len via the ACPI tree.

Thanks,
Jesse

Alex Chiang (1):
      PCI Hotplug: acpiphp: don't store a pci_dev in acpiphp_func

 drivers/pci/hotplug/acpiphp.h      |    1 -
 drivers/pci/hotplug/acpiphp_glue.c |   63 +++++++++++++++---------------------
 2 files changed, 26 insertions(+), 38 deletions(-)
