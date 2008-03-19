Return-Path: <linux-kernel-owner+w=401wt.eu-S943811AbYCTACk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943811AbYCTACk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1162524AbYCSWte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 18:49:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43102
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1162517AbYCSWtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 18:49:32 -0400
Date: Wed, 19 Mar 2008 15:49:47 -0700 (PDT)
Message-Id: <20080319.154947.78332548.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: ben.thery@gmail.com, tilman@imap.cc, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, pekkas@netcore.fi, yoshfuji@linux-ipv6.org,
       dlezcano@fr.ibm.com, xemul@openvz.org, rjw@sisk.pl,
       ebiederm@xmission.com
Subject: Re: [2.6.25-rc5-mm1] regression: cannot run Postfix sendmail
 command as non-root
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080319141608.ede86a86.akpm@linux-foundation.org>
References: <47D98510.60801@imap.cc>
	<939d53060803191052o2f43b75cu426d51f9f24e2a46@mail.gmail.com>
	<20080319141608.ede86a86.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 19 Mar 2008 14:16:08 -0700

> Although this is advertised as a 2.6.25-rc5-mm1 problem, I assume the
> regression is also in mainline? 2.6.25-rc6?

It is in 2.6.25-rc6, correct.

If Pavel or someone else doesn't produce a good fix soon
I'll revert the guilty change as this bug is worse than
the problem that changeset fixes.
