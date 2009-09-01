Return-Path: <linux-kernel-owner+w=401wt.eu-S1755349AbZIAWwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbZIAWwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 18:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755335AbZIAWwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 18:52:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56957
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752641AbZIAWwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 18:52:45 -0400
Date: Tue, 01 Sep 2009 15:52:59 -0700 (PDT)
Message-Id: <20090901.155259.120906603.davem@davemloft.net>
To: tj@kernel.org
Cc: mroos@linux.ee, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu: don't assume existence of cpu0
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A9D13F0.7010504@kernel.org>
References: <4A9CD41C.8060604@kernel.org>
	<Pine.SOC.4.64.0909011437270.20321@math.ut.ee>
	<4A9D13F0.7010504@kernel.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Tue, 01 Sep 2009 21:30:40 +0900

> Meelis Roos wrote:
>>> Aha...  Does the following patch fix the problem?
>> 
>> Yes, yesterdays 2.6.31-rc8-git plus this patch seems to work fine, no 
>> warnings/oopses/panics. It is happily churning on debian unstable 
>> upgrade now.
> 
> Good to hear.  Will forward to Linus right away.  Thanks.

Thanks a lot for fixing this so quickly Tejun.
