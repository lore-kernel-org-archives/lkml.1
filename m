Return-Path: <linux-kernel-owner+w=401wt.eu-S1753200AbZDZNAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbZDZNAu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 09:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbZDZNAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 09:00:41 -0400
Received: from ozlabs.org ([203.10.76.45]:37439 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbZDZNAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 09:00:41 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] virtio-rng: Remove false BUG for spurious callbacks
Date: Sun, 26 Apr 2009 22:30:36 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       Christian Borntraeger <borntraeger@de.ibm.com>, stable@kernel.org
References: <200904231642.59939.rusty@rustcorp.com.au> <alpine.LFD.2.00.0904240822410.3101@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904240822410.3101@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904262230.37157.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Apr 2009 12:53:12 am Linus Torvalds wrote:
> 
> On Thu, 23 Apr 2009, Rusty Russell wrote:
> >
> > From: Christian Borntraeger <borntraeger@de.ibm.com>
> > 
> > The virtio-rng drivers checks for spurious callbacks. Since
> > callbacks can be implemented via shared interrupts (e.g. PCI) this
> > could lead to guest kernel oopses with lots of virtio devices.
> > 
> > Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> > ---
> 
> I really would have liked a sign-off from you too, rusty. I'll take it 
> as-is, since it's trivial, but just a note..

Sorry, missed that one.

Thanks for the reminder,
Rusty.
