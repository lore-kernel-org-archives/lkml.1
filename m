Return-Path: <linux-kernel-owner+w=401wt.eu-S2992754AbXBITAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992754AbXBITAH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 14:00:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992756AbXBITAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 14:00:07 -0500
Received: from dsl3-63-249-91-56.cruzio.com ([63.249.91.56]:59221 "EHLO
	cichlid.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992754AbXBITAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 14:00:06 -0500
X-Greylist: delayed 3026 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Feb 2007 14:00:06 EST
Date: Fri, 9 Feb 2007 10:09:22 -0800
From: Andrew Burgess <aab@cichlid.com>
Message-Id: <200702091809.l19I9MgS025574@cichlid.com>
To: kernel@kolivas.org, ck@vds.kolivas.org, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: Swap prefetch merge plans
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>I'm stuck developing code I'm having trouble proving it helps. Normal users 
>find it helps and an artificial testcase shows it helps, but that is not 
>enough, since the normal users will be tainted in their opinion, and the 
>artificial testcase will always be artificial. My mistake of developing novel 
>code in areas that were unquantifiable has been my undoing.

Could you add some statistics gathering to measure
cumulatively how long processes wait for swapin?  Then you
could run with and without and maybe say "on average my
system waits 4 minutes a day without swap prefetch and 2
minutes with? Or if a simple sum doesn't work, some sort of
graph? Then anyone could run and measure the benefit.

Apologies if you've already thought of this...

