Return-Path: <linux-kernel-owner+w=401wt.eu-S1759234AbZFQJDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759234AbZFQJDG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 05:03:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756224AbZFQJCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 05:02:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44668 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755229AbZFQJCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 05:02:53 -0400
Date: Wed, 17 Jun 2009 10:02:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, dhowells@redhat.com,
       torvalds@osdl.org, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jacob Thebault-Spieker <summatusmentis@gmail.com>,
       linux-afs@lists.infradead.org
Subject: Re: [PATCH 01/17] VFS: Implement the pioctl() system call
Message-ID: <20090617100240.55c85e23@lxorguk.ukuu.org.uk>
In-Reply-To: <11610.1245197984@redhat.com>
References: <20090616205454.GA2181@infradead.org>
	<20090616203845.4526.60013.stgit@warthog.procyon.org.uk>
	<20090616203850.4526.83585.stgit@warthog.procyon.org.uk>
	<11610.1245197984@redhat.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Now, assuming I do produce such a userspace library - that does not address
> the other requirement: that of using a common set of binaries to manipulate
> both OpenAFS and kAFS without the need for recompilation.  I presume you
> advocate making OpenAFS change to suit your requirements?

If you have a library providing pioctl() it can speak brain damage to the
OpenAFS module and sensible interfaces otherwise.

The problem you are attempting to introduce simply doesn't exist.
