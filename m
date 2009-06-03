Return-Path: <linux-kernel-owner+w=401wt.eu-S1754328AbZFCIwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbZFCIwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 04:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbZFCIv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 04:51:57 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36713 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752841AbZFCIv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 04:51:57 -0400
Date: Wed, 3 Jun 2009 09:47:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Theodore Tso <tytso@mit.edu>, Dan Magenheimer <dan.magenheimer@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       George Dunlap <george.dunlap@eu.citrix.com>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, avi@redhat.com,
       xen-devel@lists.xensource.com, x86@kernel.org,
       linux-kernel@vger.kernel.org, Keir Fraser <Keir.Fraser@eu.citrix.com>,
       torvalds@linux-foundation.org, gregkh@suse.de, kurt.hackel@oracle.com,
       Ian Pratt <Ian.Pratt@eu.citrix.com>, xen-users@lists.xensource.com,
       ksrinivasan <ksrinivasan@novell.com>, EAnderson@novell.com,
       wimcoekaerts@wimmekes.net, Stephen Spector <stephen.spector@citrix.com>,
       jens.axboe@oracle.com, npiggin@suse.de
Subject: Re: Merge Xen (the hypervisor) into Linux
Message-ID: <20090603094753.6eb32099@lxorguk.ukuu.org.uk>
In-Reply-To: <4A26263A.7010809@redhat.com>
References: <20090602232843.GA6577@elte.hu>
	<793c2ffe-16d3-4e6c-9cd2-32fa089e46a3@default>
	<20090603024311.GZ31943@mit.edu>
	<4A26263A.7010809@redhat.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Linux is not the only player here.  NetBSD can run as dom0 guest. 
> Solaris can run as dom0 guest too.  Thus making the dom0/xen interface 
> private to linux and xen isn't going to fly.

It does not however preclude fixing the dom0 interface.

Anyway we deal with unfixable interfaces on a regular basis with device
hardware. What we don't do is screw up the kernel handling garbage
hardware. We dump the adaption on the driver.

Same with Xen, impedance matching Xen's interface with the kernel is (at
least initialy) something that belongs entirely in the Xen glue, or to
get started initially by just turning off stuff.

MTRR, PAE etc can all be turned off for the purpose an initial merge.

