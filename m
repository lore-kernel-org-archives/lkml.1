Return-Path: <linux-kernel-owner+w=401wt.eu-S1758316AbXI3QKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758316AbXI3QKk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 12:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbXI3QKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 12:10:33 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:57031 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbXI3QKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 12:10:32 -0400
Subject: Re: [PATCH] robust futex thread exit race
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Ulrich Drepper <drepper@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070930160601.GA31506@elte.hu>
References: <1191164539.4047.5.camel@localhost>
	 <20070930151827.GB23127@elte.hu>  <20070930160601.GA31506@elte.hu>
Content-Type: text/plain
Organization: IBM Corporation
Date: Sun, 30 Sep 2007 18:10:25 +0200
Message-Id: <1191168625.19010.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2007-09-30 at 18:06 +0200, Ingo Molnar wrote:
> > good catch! A quick preliminary review of your patch indicates it's 
> > fine - and it might be v2.6.23 material.
> 
> there's a symmetric bug in kernel/compat_futex.c too.

True. I'll update the patch and send it again with the Acked-bys.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


