Return-Path: <linux-kernel-owner+w=401wt.eu-S1757753AbYHOJJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753AbYHOJJ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 05:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbYHOJJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 05:09:47 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35080 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750920AbYHOJJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 05:09:47 -0400
Date: Fri, 15 Aug 2008 09:51:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Theodore Tso <tytso@mit.edu>
Cc: david@lang.hm, Christoph Hellwig <hch@infradead.org>,
       Eric Paris <eparis@redhat.com>, tvrtko.ursulin@sophos.com,
       andi@firstfloor.org, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       malware-list-bounces@dmesg.printk.net, peterz@infradead.org,
       viro@ZenIV.linux.org.uk
Subject: Re: [malware-list] TALPA - a threat model?  well sorta.
Message-ID: <20080815095143.65c5912b@lxorguk.ukuu.org.uk>
In-Reply-To: <20080815020400.GG13048@mit.edu>
References: <20080813192922.GI8232@mit.edu>
	<20080814093103.6CD102FE8B4@pmx1.sophos.com>
	<20080814132455.GE6469@mit.edu>
	<1218721713.3540.125.camel@localhost.localdomain>
	<20080814155028.GB8256@mit.edu>
	<1218734985.9375.5.camel@paris.rdu.redhat.com>
	<20080814191726.GG22488@mit.edu>
	<20080814193408.GA10236@infradead.org>
	<20080814194111.GH22488@mit.edu>
	<alpine.DEB.1.10.0808141837430.13400@asgard.lang.hm>
	<20080815020400.GG13048@mit.edu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> According to Eric Paris the clean/dirty state is only stored in
> memory.  We could use the extended attribute interface as a way of not
> defining a new system call, or some other interface, but I'm not sure
> it's such a great match given that the extended attributes interface
> are designed for persistent data.

This is another application layer matter. At the end of the day why does
the kernel care where this data is kept. For all we know someone might
want to centralise it or even distribute it between nodes on a clustered
file system.

Alan
