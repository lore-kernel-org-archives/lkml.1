Return-Path: <linux-kernel-owner+w=401wt.eu-S1423058AbXBBTLB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423058AbXBBTLB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 14:11:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423059AbXBBTLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 14:11:00 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:53117 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423058AbXBBTK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 14:10:59 -0500
Date: Fri, 2 Feb 2007 20:08:29 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Paul Rolland <rol@as2917.net>
cc: "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       "'Andrew Morton'" <akpm@osdl.org>,
       "'Jon Masters'" <jonathan@jonmasters.org>,
       "'Alexey Dobriyan'" <adobriyan@gmail.com>
Subject: RE: [PATCH] Ban module license tag string termination trick
In-Reply-To: <01b701c746f9$333c9d80$4b00a8c0@donald>
Message-ID: <Pine.LNX.4.61.0702022006500.27603@yvahk01.tjqt.qr>
References: <01b701c746f9$333c9d80$4b00a8c0@donald>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	0.0 UPPERCASE_25_50        message body is 25-50% uppercase
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 2 2007 19:37, Paul Rolland wrote:
>> MODULE_IS_UNDER_GPL_LICENSE("yes\0 but only this .c file");
>> 
>
>MODULE_IS_UNDER_GPL_LICENSE(0)
>(integer, not string).

So what (legally) happens when someone does
MODULE_IS_UNDER_GPL_LICENSE(2), (~0) or (-1)? Does the judge get confused?
Then better use strings and an appropriate check.


Jan
-- 
