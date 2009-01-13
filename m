Return-Path: <linux-kernel-owner+w=401wt.eu-S1758600AbZAMXyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600AbZAMXyh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 18:54:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753332AbZAMXy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 18:54:28 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39114 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbZAMXy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 18:54:27 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Miller <davem@davemloft.net>
Subject: Re: lib/klist.c: bit 0 in pointer can't be used as flag
Cc: kosaki.motohiro@jp.fujitsu.com, Jesper.Nilsson@axis.com, tj@kernel.org,
       gregkh@suse.de, stern@rowland.harvard.edu, jens.axboe@oracle.com,
       hinko.kocevar@cetrtapot.si, linux-kernel@vger.kernel.org
In-Reply-To: <20090113.144521.97357573.davem@davemloft.net>
References: <2f11576a0901131440w7fd3290uc9664aaf7aa89b08@mail.gmail.com> <20090113.144521.97357573.davem@davemloft.net>
Message-Id: <20090114085341.442C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Wed, 14 Jan 2009 08:54:20 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Date: Wed, 14 Jan 2009 07:40:19 +0900
> 
> > > It may be that we've worked around the other spots, although I haven't
> > > seen anything like that, we might just have been lucky until now.
> > >
> > > Can you recall another place where this trick is used?
> > 
> > rmap.
> > Don't CRIS use mmu?
> 
> I'm beginning to suspect the issue is only with objects
> in the kernel image itself.  Dynamically allocated memory
> is properly aligned and therefore the "low bit status bits
> in pointer" trick works.

Ah, I see.
very thank you for helpful explain.



