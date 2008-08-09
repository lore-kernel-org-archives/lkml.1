Return-Path: <linux-kernel-owner+w=401wt.eu-S1762069AbYHIHhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762069AbYHIHhA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 03:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbYHIHgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 03:36:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45897
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753576AbYHIHgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 03:36:49 -0400
Date: Sat, 09 Aug 2008 00:36:50 -0700 (PDT)
Message-Id: <20080809.003650.78513833.davem@davemloft.net>
To: haoki@redhat.com
Cc: herbert@gondor.apana.org.au, m.s.tsirkin@gmail.com,
       linux-kernel@vger.kernel.org, yoshfuji@linux-ipv6.org,
       netdev@vger.kernel.org
Subject: Re: possible recursive locking in udp4_lib_rcv
From: David Miller <davem@davemloft.net>
In-Reply-To: <489D13F9.4000805@redhat.com>
References: <20080808143741.GA20777@gondor.apana.org.au>
	<20080808150108.GA21048@gondor.apana.org.au>
	<489D13F9.4000805@redhat.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hideo AOKI <haoki@redhat.com>
Date: Fri, 08 Aug 2008 23:50:17 -0400

> Hello Herbert,
> 
> Herbert Xu wrote:
> > On Fri, Aug 08, 2008 at 10:37:41PM +0800, Herbert Xu wrote:
> >> Never mind, I see the reason why it's there.  What we should do
> >> is drop the lock when we hit an encapsulated socket since they
> >> don't need it at all.
> > 
> > Here is the patch:
> > 
> > udp: Drop socket lock for encapsulated packets
> 
> Thank very much for fixing the bug.

Indeed, thanks Herbert.

Applied to net-2.6, and queued up for -stable.
