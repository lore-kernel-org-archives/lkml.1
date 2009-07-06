Return-Path: <linux-kernel-owner+w=401wt.eu-S1754349AbZGFCEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349AbZGFCEH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 22:04:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbZGFCDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 22:03:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35929
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752893AbZGFCDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 22:03:54 -0400
Date: Sun, 05 Jul 2009 19:04:00 -0700 (PDT)
Message-Id: <20090705.190400.130883789.davem@davemloft.net>
To: mingo@elte.hu
Cc: eric.dumazet@gmail.com, joerg.roedel@amd.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       aabdulla@nvidia.com
Subject: Re: [GIT]: Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090703214609.GA7776@elte.hu>
References: <4A4CBE7D.2060603@gmail.com>
	<20090702200526.GA2969@elte.hu>
	<20090703214609.GA7776@elte.hu>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 3 Jul 2009 23:46:09 +0200

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>> * Eric Dumazet <eric.dumazet@gmail.com> wrote:
>> 
>> > We might have a race in napi_schedule(), leaving interrupts 
>> > disabled forever. I cannot test this patch, I dont have the 
>> > hardware...
>> 
>> I have tested it and the config that failed before works now. (as 
>> do other configs as well)
>> 
>> I'll have to re-test whether the failing config fails with your 
>> fix reverted - that will have to wait until tomorrow or so.
> 
> update: that forcedeth system is still working fine.

I've applied Eric's patch, thanks!
