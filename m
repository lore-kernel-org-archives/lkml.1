Return-Path: <linux-kernel-owner+w=401wt.eu-S1751970AbXDDVip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970AbXDDVip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 17:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbXDDVip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 17:38:45 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:54027 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970AbXDDVio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 17:38:44 -0400
Subject: Re: [PATCH 2.6.21-rc5] kernel/time.c: add missing symbol exports
From: john stultz <johnstul@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Bittermann <t.bittermann@online.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20070404143052.b1572cc9.akpm@linux-foundation.org>
References: <461408A6.5010005@online.de>
	 <20070404140007.15aa1893.akpm@linux-foundation.org>
	 <461414E7.6080302@online.de>
	 <20070404143052.b1572cc9.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 14:38:30 -0700
Message-Id: <1175722710.17711.70.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-04 at 14:30 -0700, Andrew Morton wrote:
> On Wed, 04 Apr 2007 23:13:11 +0200
> Thomas Bittermann <t.bittermann@online.de> wrote:
> 
> > Andrew Morton schrieb:
> > > On Wed, 04 Apr 2007 22:20:54 +0200
> > > Thomas Bittermann <t.bittermann@online.de> wrote:
> > > 
> > >> This patch adds 2 missing symbol exports:
> > >>
> > >> jiffies_to_timeval
> > >> timeval_to_jiffies
> > > 
> > > I don't see any in-tree code which needs these symbols?
> > > 
> > > The exports might make sense from a consistency POV, but I'd be interested
> > > in knowing what motivated this change?
> > I'm working on a Fedora 7 LiveCD which integrates dm-raid4-5
> > (http://people.redhat.com/~heinzm/sw/dm/dm-raid45/readme). dm-raid4-5.c uses
> > jiffies_to_timeval() ...
> > 
> 
> Fair enough.
> 
> John/Ingo/Thomas: have you any problems with exporting the above to modules
> (with EXPORT_SYMBOL)?

As long as jiffies and HZ is exported, I don't see why not.

thanks
-john



