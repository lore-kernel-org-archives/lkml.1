Return-Path: <linux-kernel-owner+w=401wt.eu-S1752646AbYFCHxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbYFCHxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 03:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750818AbYFCHxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 03:53:38 -0400
Received: from main.gmane.org ([80.91.229.2]:35816 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbYFCHxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 03:53:37 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: linux-next: WARNING: at kernel/lockdep.c:2680 check_flags+0x98/0x151()
Date: Tue, 03 Jun 2008 08:53:21 +0100
Message-ID: <g22t9h$b01$1@ger.gmane.org>
References: <4844868F.20104@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: cpc1-cwma5-0-0-cust137.swan.cable.ntl.com
User-Agent: KNode/0.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Winchester wrote:

> In next-20080530 and next-20080602 (and possibly earlier - I can't
> remember the linux-next tree before that I tried) I get the following:
> 
> [   12.885153] ------------[ cut here ]------------
> [   12.885203] WARNING: at kernel/lockdep.c:2680 check_flags+0x98/0x151()
> [   12.885248] Pid: 4, comm: watchdog/0 Not tainted
> 2.6.26-rc4-next-20080602 #13

I saw this and mentioned it too - 
http://groups.google.co.uk/group/fa.linux.kernel/browse_thread/thread/77d4cedb7b27fa3b/fc66f2d849b42031?lnk=gst&q=watchdog+sitsofe#fc66f2d849b42031 .

> This is completely reproducible on every boot - should I try to bisect it?

Things that have been bisected seem far more likely to be looked at so if
you have the stomach... If you do start bisection I can confirm that it is
in next-20080529 . I can also mention that on my system the warning seems
to go away if I boot with nmi_watchdog=2 .

-- 
Sitsofe | http://sucs.org/~sits/

