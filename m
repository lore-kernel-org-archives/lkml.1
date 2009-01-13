Return-Path: <linux-kernel-owner+w=401wt.eu-S1756405AbZAMWpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405AbZAMWpe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 17:45:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbZAMWpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 17:45:22 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37414
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751243AbZAMWpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 17:45:20 -0500
Date: Tue, 13 Jan 2009 14:45:21 -0800 (PST)
Message-Id: <20090113.144521.97357573.davem@davemloft.net>
To: kosaki.motohiro@jp.fujitsu.com
Cc: Jesper.Nilsson@axis.com, tj@kernel.org, gregkh@suse.de,
       stern@rowland.harvard.edu, jens.axboe@oracle.com,
       hinko.kocevar@cetrtapot.si, linux-kernel@vger.kernel.org
Subject: Re: lib/klist.c: bit 0 in pointer can't be used as flag
From: David Miller <davem@davemloft.net>
In-Reply-To: <2f11576a0901131440w7fd3290uc9664aaf7aa89b08@mail.gmail.com>
References: <20090113.131030.207355839.davem@davemloft.net>
	<20090113221235.GD19262@axis.com>
	<2f11576a0901131440w7fd3290uc9664aaf7aa89b08@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Wed, 14 Jan 2009 07:40:19 +0900

> > It may be that we've worked around the other spots, although I haven't
> > seen anything like that, we might just have been lucky until now.
> >
> > Can you recall another place where this trick is used?
> 
> rmap.
> Don't CRIS use mmu?

I'm beginning to suspect the issue is only with objects
in the kernel image itself.  Dynamically allocated memory
is properly aligned and therefore the "low bit status bits
in pointer" trick works.
