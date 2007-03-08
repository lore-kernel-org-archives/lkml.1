Return-Path: <linux-kernel-owner+w=401wt.eu-S933187AbXCHTeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187AbXCHTeL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 14:34:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933188AbXCHTeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 14:34:10 -0500
Received: from mtaout5.012.net.il ([84.95.2.13]:29219 "EHLO mtaout5.012.net.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933187AbXCHTeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 14:34:08 -0500
Date: Thu, 08 Mar 2007 21:34:00 +0200
From: Avi Kivity <avi@argo.co.il>
Subject: Re: [patch 2/5] signalfd v2 - signalfd core ...
In-reply-to: <Pine.LNX.4.64.0703081113060.7515@alien.or.mcafeemobile.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "David M. Lloyd" <dmlloyd@flurg.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Message-id: <45F06528.7040506@argo.co.il>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
X-Greylist: Sender IP whitelisted,
 not delayed by milter-greylist-2.1.12 (firebolt.argo.co.il [0.0.0.0]); Thu,
 08 Mar 2007 21:34:00 +0200 (IST)
References: <Pine.LNX.4.64.0703071712210.3672@alien.or.mcafeemobile.com>
 <1173364264.6891.3.camel@localhost>
 <Pine.LNX.4.64.0703080742220.7015@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0703080812290.10832@woody.linux-foundation.org>
 <Pine.LNX.4.64.0703080825420.7015@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0703080852170.10832@woody.linux-foundation.org>
 <Pine.LNX.4.64.0703081113060.7515@alien.or.mcafeemobile.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi wrote:
> So, to cut it short, I can do the pseudo-siginfo read(2), but I don't 
> like it too much (little, actually). The siginfo, as bad as it is, is a 
> standard used in many POSIX APIs (hence even in kernel), and IMO if we 
> want to send that back, a struct siginfo should be.
>   

You can send the data in the 32/64 neutral format, and have glibc 
convert it to a siginfo, and everybody's happy.


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

