Return-Path: <linux-kernel-owner+w=401wt.eu-S1763651AbYCEWQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763651AbYCEWQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 17:16:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763009AbYCEWQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 17:16:24 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42820
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1762952AbYCEWQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 17:16:23 -0500
Date: Wed, 05 Mar 2008 14:16:22 -0800 (PST)
Message-Id: <20080305.141622.80343656.davem@davemloft.net>
To: richard.guenther@gmail.com
Cc: hpa@zytor.com, Joe.Buck@synopsys.com, matz@suse.de, hubicka@ucw.cz,
       aurelien@aurel32.net, linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt
 direction flag
From: David Miller <davem@davemloft.net>
In-Reply-To: <84fc9c000803051340i13559c63tcf56eb828d000802@mail.gmail.com>
References: <84fc9c000803051332q2f2eedeej7d3c0509e698cabf@mail.gmail.com>
	<47CF11D6.7070901@zytor.com>
	<84fc9c000803051340i13559c63tcf56eb828d000802@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Richard Guenther" <richard.guenther@gmail.com>
Date: Wed, 5 Mar 2008 22:40:59 +0100

> Right.  So this problem is over-exaggerated.  It's not like
> "any binary you create on that system will be broken on any
> other existing system."

I will be sure to hunt you down to help debug when someone reports
that once every few weeks their multi-day simulation gives incorrect
results :-)

This is one of those cases where the bug is going to be a huge
issue to people who actually hit it, and since we know about the
problem, knowingly shipping something in that state is unforgivable.
