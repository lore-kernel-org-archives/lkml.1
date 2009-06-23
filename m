Return-Path: <linux-kernel-owner+w=401wt.eu-S1758950AbZFWWnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950AbZFWWnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 18:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755634AbZFWWnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 18:43:22 -0400
Received: from gate.crashing.org ([63.228.1.57]:36371 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754356AbZFWWnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 18:43:21 -0400
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
       Avi Kivity <avi@redhat.com>, Ian Campbell <Ian.Campbell@eu.citrix.com>
In-Reply-To: <4A41562F.1040901@goop.org>
References: <20090622140807.25509.54448.stgit@bob.kio>
	 <20090622143431.GT19977@parisc-linux.org> <4A3FCB68.3030004@goop.org>
	 <20090622183056.GY19977@parisc-linux.org> <1245714008.4017.7.camel@pasglop>
	 <20090623190826.GJ19977@parisc-linux.org>  <4A413C66.5010306@goop.org>
	 <1245793758.10356.27.camel@pasglop>  <4A41562F.1040901@goop.org>
Content-Type: text/plain
Date: Wed, 24 Jun 2009 08:41:56 +1000
Message-Id: <1245796916.10356.40.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-23 at 15:24 -0700, Jeremy Fitzhardinge wrote:
> I guess we could fake up OF-like datastructures or something, but I
> don't see what wide application that would have.  It might help in this
> case, but its a lot more complex than just calling
> pci_scan_single_device() at the appropriate place.

It would be indeed more complex and probably not something to do
right now to solve that specific problem

> Do you have any other cases in mind where it would be helpful?

Well, it might be for virtual device discovery etc... but don't bother
now. We might talk about it at KS for those interested. It's more
something we see as useful for embedded archs at the moment but in the
long run it might make sense for hypervisors as well.

Cheers,
Ben.

