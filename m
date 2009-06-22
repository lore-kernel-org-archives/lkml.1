Return-Path: <linux-kernel-owner+w=401wt.eu-S1752788AbZFVOgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbZFVOgX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 10:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752871AbZFVOgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 10:36:12 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:49648 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbZFVOgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 10:36:11 -0400
Date: Mon, 22 Jun 2009 08:36:13 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Alex Chiang <achiang@hp.com>, jbarnes@virtuousgeek.org,
       linux-arch@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
       Tony Luck <tony.luck@intel.com>, Russell King <linux@arm.linux.org.uk>,
       Arnd Bergmann <arnd@arndb.de>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>, Paul Mundt <lethal@linux-sh.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Ingo Molnar <mingo@redhat.com>, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] PCI: remove pcibios_scan_all_fns()
Message-ID: <20090622143613.GU19977@parisc-linux.org>
References: <20090622140807.25509.54448.stgit@bob.kio> <20090622142602.GA25289@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090622142602.GA25289@linux-mips.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 03:26:02PM +0100, Ralf Baechle wrote:
> On Mon, Jun 22, 2009 at 08:08:07AM -0600, Alex Chiang wrote:
> > This was #define'd as 0 on all platforms, so let's get rid of it.
> > 
> > This change makes pci_scan_slot() slightly easier to read.
> 
> I don't see why one would want to have a non-zero pcibios_scan_all_fns()
> anyway.

If you have real hardware, absolutely.  If you have a hypervisor that
gives you function 5 of a device (instead of mapping your function 0 to
function 5 of the real device), you'll want something along these lines.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
