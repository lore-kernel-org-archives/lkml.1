Return-Path: <linux-kernel-owner+w=401wt.eu-S1754450AbZF2UeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbZF2UeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 16:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbZF2Udu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 16:33:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:49006 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbZF2Udt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 16:33:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,311,1243839600"; 
   d="scan'208";a="703555704"
Date: Mon, 29 Jun 2009 13:33:50 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: Alex Chiang <achiang@hp.com>
Cc: linux-arch@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
       Tony Luck <tony.luck@intel.com>, Russell King <linux@arm.linux.org.uk>,
       Arnd Bergmann <arnd@arndb.de>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>, David Howells <dhowells@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Ingo Molnar <mingo@redhat.com>, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] PCI: remove pcibios_scan_all_fns()
Message-ID: <20090629133350.66024000@jbarnes-g45>
In-Reply-To: <20090622140807.25509.54448.stgit@bob.kio>
References: <20090622140807.25509.54448.stgit@bob.kio>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.17.2; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jun 2009 08:08:07 -0600
Alex Chiang <achiang@hp.com> wrote:

> This was #define'd as 0 on all platforms, so let's get rid of it.
> 
> This change makes pci_scan_slot() slightly easier to read.
> 
> Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Kyle McMartin <kyle@mcmartin.ca>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jeff Dike <jdike@addtoit.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Alex Chiang <achiang@hp.com>
> ---

Applied this to my linux-next tree, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
