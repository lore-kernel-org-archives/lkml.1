Return-Path: <linux-kernel-owner+w=401wt.eu-S1752284AbZG0QmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbZG0QmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 12:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbZG0QmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 12:42:20 -0400
Received: from fifo99.com ([67.223.236.141]:50160 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbZG0QmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 12:42:20 -0400
Subject: Re: [Patch RFC 36/37] fs: Convert bd_mount_sem to mutex
From: Daniel Walker <dwalker@fifo99.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       matthias@kaehlcke.net, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Al Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <alpine.LFD.2.00.0907271730260.2936@localhost.localdomain>
References: <20090726081459.455111897@linutronix.de>
	 <20090726081558.081388099@linutronix.de>
	 <20090727152635.GD31597@infradead.org>
	 <alpine.LFD.2.00.0907271730260.2936@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 27 Jul 2009 09:42:28 -0700
Message-Id: <1248712948.28841.56.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-27 at 17:30 +0200, Thomas Gleixner wrote:
> On Mon, 27 Jul 2009, Christoph Hellwig wrote:
> 
> > On Sun, Jul 26, 2009 at 08:20:38AM -0000, Thomas Gleixner wrote:
> > > bd_mount_sem is used as mutex so make it a mutex.
> > 
> > Actually we may return to userspace with it held, so the conversion
> > is a bad idea.  But I have a patch I need to post to completely get
> > rid of it.
> 
> That's why it's RFC :)

You better inspect these at much greater detail.. Matthias (added to the
CC) , and I did a great number of semaphore to mutex changes and I don't
recall there being too many clear easy ones remaining .. So unless the
semaphore was added in the past 12 months or so , I'd treat it as likely
unsafe for converting to a mutex..

Daniel

