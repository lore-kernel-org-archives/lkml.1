Return-Path: <linux-kernel-owner+w=401wt.eu-S1758205AbYBTFaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbYBTFaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 00:30:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbYBTFaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 00:30:05 -0500
Received: from gate.crashing.org ([63.228.1.57]:52063 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303AbYBTFaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 00:30:03 -0500
Cc: sparclinux@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Message-Id: <1E43CE53-98E0-4D98-9629-9E3336A25BAE@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: David Miller <davem@davemloft.net>
In-Reply-To: <20080219.212655.173468988.davem@davemloft.net>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [PATCH] [LMB]: Fix lmb_add_region if region should be added at the head
Date: Tue, 19 Feb 2008 23:29:55 -0600
References: <Pine.LNX.4.64.0802192227170.2215@blarg.am.freescale.net> <20080219.204525.193731674.davem@davemloft.net> <7A7ECF09-E547-4C04-A388-C3E8755478DD@kernel.crashing.org> <20080219.212655.173468988.davem@davemloft.net>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 19, 2008, at 11:26 PM, David Miller wrote:

> From: Kumar Gala <galak@kernel.crashing.org>
> Date: Tue, 19 Feb 2008 23:16:18 -0600
>
>> The for loop above the code I added will move all the existing slots
>> up one.  Its just the tail cleanup we are missing.
>
> Aha, I see how this works now, thanks!
>
> I'll add this to my LMB tree.

Sounds good.  Now just convince Paul or Linus to pull this in for  
2.6.25 :)

- k
