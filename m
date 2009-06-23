Return-Path: <linux-kernel-owner+w=401wt.eu-S1755558AbZFWB34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbZFWB34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 21:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbZFWB3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 21:29:47 -0400
Received: from gate.crashing.org ([63.228.1.57]:44744 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313AbZFWB3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 21:29:47 -0400
Subject: Re: [PATCH] PCI: remove pcibios_scan_all_fns()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Alex Chiang <achiang@hp.com>,
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
In-Reply-To: <4A4019F9.4020702@goop.org>
References: <20090622140807.25509.54448.stgit@bob.kio>
	 <20090622143431.GT19977@parisc-linux.org> <4A3FCB68.3030004@goop.org>
	 <20090622183056.GY19977@parisc-linux.org>  <4A4019F9.4020702@goop.org>
Content-Type: text/plain
Date: Tue, 23 Jun 2009 10:33:53 +1000
Message-Id: <1245717233.4017.21.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-22 at 16:55 -0700, Jeremy Fitzhardinge wrote:
> 
> I wonder if that would upset drivers.  Assuming they can cope with just
> being given some functions, how could one generically make a function
> look present-but-dummy enough to not upset the driver?

Well, the dummy function would have a totally different vid/did, I think
that would work. In general, while I've seen drivers that -do- need to
know their real function number to get to the right registers, I haven't
seen much that also need to see function 0 "right" (or if they do, then
function 0 just needs to be plugged in the same partition and the whole
problem is somewhat moot).

Cheers,
Ben.

