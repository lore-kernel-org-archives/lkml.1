Return-Path: <linux-kernel-owner+w=401wt.eu-S1752413AbYGWP3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413AbYGWP3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 11:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbYGWP3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 11:29:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:57317 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbYGWP3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 11:29:15 -0400
Date: Wed, 23 Jul 2008 08:14:03 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: 7eggert@gmx.de
Cc: "Rafael C. de Almeida" <almeidaraf@gmail.com>,
       Eric Paris <eparis@redhat.com>, malware-list@lists.printk.net,
       linux-kernel@vger.kernel.org
Subject: Re: request for comment: generic kernel interface for malware
 vendors
Message-ID: <20080723081403.4c615bcb@infradead.org>
In-Reply-To: <E1KLdgU-0001a9-7F@be1.7eggert.dyndns.org>
References: <aRVce-Em-3@gated-at.bofh.it>
	<aS7Go-7AK-3@gated-at.bofh.it>
	<E1KLdgU-0001a9-7F@be1.7eggert.dyndns.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jul 2008 14:43:09 +0200
Bodo Eggert <7eggert@gmx.de> wrote:

> Rafael C. de Almeida <almeidaraf@gmail.com> wrote:
> > Eric Paris wrote:
> 
> >> [Kernel support for malware scanners]
> 
> > I'm a newbie here, so don't take me too serious. But I don't see why
> > that needs a kernel interface, at least from the example on the
> > Documentation directory (patch 9). Seems to me you could just use
> > file permission to deny or allow the access for a certain file. The
> > only thing that would be a little trickier from user-space is to
> > know when a given file is read. So, talpa should do only that or
> > you could take advantage of preload like trickle does for bandwidth
> > shapping.
> 
> How do you ensure that the LD_PRELOAD variable stays intact and will
> be honored by all applications - including that commercial one
> supplying it's own libc, by suid-binaries and by programs written in
> a non-libc-language?

neither approach is fool proof for that matter
it's just a matter of how high you want to put the bar.

that's why it's really important to see the design ideas for this
code... to figure out what it is supposed to do ;)

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
