Return-Path: <linux-kernel-owner+w=401wt.eu-S1755672AbYHSRSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672AbYHSRSy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 13:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbYHSRSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 13:18:46 -0400
Received: from web82205.mail.mud.yahoo.com ([209.191.86.100]:47918 "HELO
	web82205.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753064AbYHSRSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 13:18:45 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Aug 2008 13:18:45 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=Ag7Cl1ymM9z7NaxHHPW4PIt+X38sDLfxae0OhLcWPXQkSGYhkwSCwhqnXop0rMxTrMaI7HnNkmvY0ztac0KIMMakTygyTe2JwTsaqAoHQqFj7g+fSd9Prq53Ukh8N9EYYZGrWCv/+GPDQzmFL0wSjllaG/BQsTvoxpn0xWTlG/k=;
X-YMail-OSG: 89_bf9kVM1nDfDvUmdxZGKHWe04OeKvoyqwgh0d_5xNU3Ltrti9timnTuripHwkmNOwZ4Y_U0f9V87lNUx09BkfckINBA33HtLUPc9Gdo93ACr0xmSf5Gb4UkHc6cIs-
Date: Tue, 19 Aug 2008 10:12:04 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [BUG] rtc uie emulation deadlocks
To: Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>
Cc: a.zummo@towertech.it, Linux Kernel List <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>
In-Reply-To: <20080819005320.00075dba.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <915094.18966.qm@web82205.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 11 Aug 2008 14:43:39 +0100 Russell King
> <rmk+lkml@arm.linux.org.uk> wrote:
> 
> > The locking looks a rather random in there, so I'm not going to try to
> > create a patch.
> > 
> 
> Looks like this was caused by
> 
> commit 5ad31a575157147b43fa84ef1e21471661653878
> Author: David Brownell <david-b@pacbell.net>
> Date:   Wed Jul 23 21:30:33 2008 -0700
> 
>     rtc: remove BKL for ioctl()

I'm sure I saw someone else's fixup patch for that a couple weeks ago.
(Looks).  Yes:

http://groups.google.com/group/rtc-linux/browse_thread/thread/ad65b883739f8c92#
