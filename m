Return-Path: <linux-kernel-owner+w=401wt.eu-S1754831AbYDXA1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831AbYDXA1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 20:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbYDXA1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 20:27:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39221
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752243AbYDXA1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 20:27:09 -0400
Date: Wed, 23 Apr 2008 17:27:10 -0700 (PDT)
Message-Id: <20080423.172710.152976766.davem@davemloft.net>
To: a.p.zijlstra@chello.nl
Cc: mingo@elte.hu, dhaval@linux.vnet.ibm.com, vatsa@in.ibm.com,
       dmitry.adamushko@gmail.com, linux-kernel@vger.kernel.org, efault@gmx.de
Subject: Re: [RFC][PATCH 1/2] sched: higher granularity load on 64bit
 systems
From: David Miller <davem@davemloft.net>
In-Reply-To: <1208988476.2849.8.camel@lappy>
References: <1208988476.2849.8.camel@lappy>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu, 24 Apr 2008 00:07:56 +0200

> The below is an RFC because for some reason it regresses kbuild by 5% on
> my machine (and more on the largesmp that are the reason for it).

This causes my 64-cpu Niagara2 box to completely hang when I run "make
clean" on a kernel tree after a fresh bootup.

Can we just revert all of this broken code until it's sorted out? :-/

We're going on 4 days with unfixed major regressions from the
scheduler tree merge, and these regressions make systems unusable.

This is blocking my own work, and I'm starting to lose my patience.

