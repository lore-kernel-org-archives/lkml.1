Return-Path: <linux-kernel-owner+w=401wt.eu-S1756411AbYHOKhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411AbYHOKhd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 06:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbYHOKhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 06:37:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56777 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626AbYHOKhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 06:37:23 -0400
Subject: Re: TALPA - a threat model?  well sorta.
From: Peter Zijlstra <peterz@infradead.org>
To: Helge Hafting <helge.hafting@aitel.hist.no>
Cc: Eric Paris <eparis@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       andi@firstfloor.org, riel@redhat.com, greg@kroah.com, tytso@mit.edu,
       viro@ZenIV.linux.org.uk, alan@lxorguk.ukuu.org.uk, hch@infradead.org
In-Reply-To: <48A55574.9070508@aitel.hist.no>
References: <1218645375.3540.71.camel@localhost.localdomain>
	 <20080813103951.1e3e5827@infradead.org>
	 <1218653864.3540.109.camel@localhost.localdomain>
	 <20080813143908.38796217@infradead.org>
	 <1218723133.3540.137.camel@localhost.localdomain>
	 <48A55574.9070508@aitel.hist.no>
Content-Type: text/plain
Date: Fri, 15 Aug 2008 12:37:25 +0200
Message-Id: <1218796645.10800.242.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-15 at 12:07 +0200, Helge Hafting wrote:
> It seems to me that this "scan on file open" business is the
> wrong way to do things - because it reduces performance.
> 
> If you scan on file open, then your security sw is too late and
> getting in the way.
> 
> It is better to scan in advance. Most machines has lots of idle time.
> Use that time to scan in advance, and mark the files as "clean".
> 
> A "clean" file can be opened without further checking anytime - giving
> normal high performance.  A file that gets written to becomes "dirty"
> until checked again. Some mechanism for making a clean copy of a
> clean file might help avoid excessive "dirtying".
> 
> "Scan on open" might still be useful for cases when the system
> haven't kept up with writing, but please don't aim to have
> this be the _primary_ mode of scanning. A file server
> where most of the stuff is pre-scanned will likely perform much better
> than  one scanning everything on open.

This is the source of all that scan on write/close rambling I've seen go
past the last couple of days..

So I'd not worry about this particular aspect

