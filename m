Return-Path: <linux-kernel-owner+w=401wt.eu-S1753505AbZFWCXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbZFWCXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 22:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbZFWCXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 22:23:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:54328 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbZFWCXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 22:23:37 -0400
Subject: Re: [PATCH] PCI: remove pcibios_scan_all_fns()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Alex Chiang <achiang@hp.com>,
       jbarnes@virtuousgeek.org, linux-arch@vger.kernel.org,
       Kyle McMartin <kyle@mcmartin.ca>, Tony Luck <tony.luck@intel.com>,
       Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>, David Howells <dhowells@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Ingo Molnar <mingo@redhat.com>, "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20090623014322.GA6729@sequoia.sous-sol.org>
References: <20090622140807.25509.54448.stgit@bob.kio>
	 <20090622143431.GT19977@parisc-linux.org>
	 <20090623014322.GA6729@sequoia.sous-sol.org>
Content-Type: text/plain
Date: Tue, 23 Jun 2009 12:22:09 +1000
Message-Id: <1245723729.4017.31.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-22 at 18:43 -0700, Chris Wright wrote:
> > I'd like to know what the KVM / Xen / ... people think about this.
> > I don't know if they rely on function 5 being able to show up out of
> > the blue.
> 
> KVM does not rely on this.  Typically a multi-function device's BDF
> gets
> remapped between host and guest (usually becoming a single function,
> function 0).

I'm surprised you don't hit problems with some devices/drivers here,
I have distinct memories of seeing such things as drivers who need
to know their own function number reliably.

Cheers,
Ben.


