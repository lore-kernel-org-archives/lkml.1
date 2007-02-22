Return-Path: <linux-kernel-owner+w=401wt.eu-S1751996AbXBVWeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbXBVWeQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 17:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbXBVWeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 17:34:16 -0500
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:41339 "EHLO
	fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbXBVWeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 17:34:15 -0500
Date: Thu, 22 Feb 2007 23:31:22 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Tom Burns <tom.i.burns@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [r8169] Any success with RTL8110SC?
Message-ID: <20070222223122.GA28191@electric-eye.fr.zoreil.com>
References: <671c20540702221117p3f5c16b3h52173c94d17f7eda@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <671c20540702221117p3f5c16b3h52173c94d17f7eda@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tom Burns <tom.i.burns@gmail.com> :
[...]
> 2.6.15-1 - it was trivial changes aside from 2.6.20.1 which required
> changes to the task scheduling code, but I'm pretty certain I didn't
> break anything.

I do not have the answar that you expect but some information could help:
- which motherboard is it ?
- can you send a dmesg for 2.6.20.1 as well as a lspci -vvx from your
  computer ?

[...]
> The r1000 driver seems to be able to send data on the wire for about a
> minute, receive packets back about 5% of the time, and after a minute
> stop working altogether, complaining that the "send buffer is full."

If I read you correctly, this version of the driver is less broken than
the others, right ?

If you are brave, you can try the patch below against 2.6.20-rc1:
http://www.fr.zoreil.com/people/francois/misc/20070221-2.6.21-rc1-r8169-test.patch

-- 
Ueimor
