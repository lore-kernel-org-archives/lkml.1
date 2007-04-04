Return-Path: <linux-kernel-owner+w=401wt.eu-S1751948AbXDDVeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbXDDVeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 17:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbXDDVeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 17:34:21 -0400
Received: from smtp.osdl.org ([65.172.181.24]:57118 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948AbXDDVeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 17:34:21 -0400
Date: Wed, 4 Apr 2007 14:30:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Bittermann <t.bittermann@online.de>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2.6.21-rc5] kernel/time.c: add missing symbol exports
Message-Id: <20070404143052.b1572cc9.akpm@linux-foundation.org>
In-Reply-To: <461414E7.6080302@online.de>
References: <461408A6.5010005@online.de>
	<20070404140007.15aa1893.akpm@linux-foundation.org>
	<461414E7.6080302@online.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Apr 2007 23:13:11 +0200
Thomas Bittermann <t.bittermann@online.de> wrote:

> Andrew Morton schrieb:
> > On Wed, 04 Apr 2007 22:20:54 +0200
> > Thomas Bittermann <t.bittermann@online.de> wrote:
> > 
> >> This patch adds 2 missing symbol exports:
> >>
> >> jiffies_to_timeval
> >> timeval_to_jiffies
> > 
> > I don't see any in-tree code which needs these symbols?
> > 
> > The exports might make sense from a consistency POV, but I'd be interested
> > in knowing what motivated this change?
> I'm working on a Fedora 7 LiveCD which integrates dm-raid4-5
> (http://people.redhat.com/~heinzm/sw/dm/dm-raid45/readme). dm-raid4-5.c uses
> jiffies_to_timeval() ...
> 

Fair enough.

John/Ingo/Thomas: have you any problems with exporting the above to modules
(with EXPORT_SYMBOL)?

