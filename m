Return-Path: <linux-kernel-owner+w=401wt.eu-S1756263AbZFWVt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263AbZFWVt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 17:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbZFWVtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 17:49:18 -0400
Received: from gate.crashing.org ([63.228.1.57]:39436 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbZFWVtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 17:49:17 -0400
Subject: Re: [PATCH] PCI: remove pcibios_scan_all_fns()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Alex Chiang <achiang@hp.com>,
       jbarnes@virtuousgeek.org, linux-arch@vger.kernel.org,
       Kyle McMartin <kyle@mcmartin.ca>, Tony Luck <tony.luck@intel.com>,
       Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>, David Howells <dhowells@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Ingo Molnar <mingo@redhat.com>, "David S. Miller" <davem@davemloft.net>,
       Avi Kivity <avi@redhat.com>
In-Reply-To: <20090623190826.GJ19977@parisc-linux.org>
References: <20090622140807.25509.54448.stgit@bob.kio>
	 <20090622143431.GT19977@parisc-linux.org> <4A3FCB68.3030004@goop.org>
	 <20090622183056.GY19977@parisc-linux.org> <1245714008.4017.7.camel@pasglop>
	 <20090623190826.GJ19977@parisc-linux.org>
Content-Type: text/plain
Date: Wed, 24 Jun 2009 07:47:44 +1000
Message-Id: <1245793664.10356.25.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-23 at 13:08 -0600, Matthew Wilcox wrote:
> 
> I think simply materialising them, either the way the OF code does,
> or the way the IOV code does is the best route forwards.

Agreed. I'm fine with removing pcibios_scan_all_fns() for now anyway,
and leave whatever arch do care with the responsibility of finding a
solution though :-)

Regarding the OF stuff, I'll see what I can do vs. moving it to
drivers/pci some time next week after I'm done fixing the regressions
from this merge window :-)

Cheers,
Ben.


