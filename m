Return-Path: <linux-kernel-owner+w=401wt.eu-S933846AbZJFW5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933846AbZJFW5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 18:57:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933076AbZJFW5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 18:57:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34276
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932867AbZJFW5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 18:57:10 -0400
Date: Tue, 06 Oct 2009 15:57:05 -0700 (PDT)
Message-Id: <20091006.155705.26059456.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: torvalds@linux-foundation.org, joao.ramos@inov.pt, david@fries.net,
       d.stussy@yahoo.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Revert "Revert "ide: try to use PIO Mode 0 during
 probe if possible""
From: David Miller <davem@davemloft.net>
In-Reply-To: <200910070052.37964.bzolnier@gmail.com>
References: <200910070027.45678.bzolnier@gmail.com>
	<20091006.154120.153174904.davem@davemloft.net>
	<200910070052.37964.bzolnier@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Wed, 7 Oct 2009 00:52:37 +0200

> On Wednesday 07 October 2009 00:41:20 David Miller wrote:
>> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>> Date: Wed, 7 Oct 2009 00:27:45 +0200
>> 
>> > The root cause of reported system hangs was (now fixed) sis5513 bug
>> > and not "ide: try to use PIO Mode 0 during probe if possible" change
>> > (commit 6029336426a2b43e4bc6f4a84be8789a047d139e) so the revert was
>> > incorrect (it simply replaced one regression with the other one).
>> 
>> What is this older "regression" fixed by the PIO-0 change?
>> 
>> You're not explaining it and neither does the commit message for the
>> PIO-0 change.
> 
> It does:
> 
> | Subject: [PATCH] sis5513: fix PIO setup for ATAPI devices

Sorry, I wasn't clear.

I'm talking about commit 6029336426a2b43e4bc6f4a84be8789a047d139e, it
doesn't say why we want to try PIO 0 mode during probe.

What was the regression fixed by that change?

