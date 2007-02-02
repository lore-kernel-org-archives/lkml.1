Return-Path: <linux-kernel-owner+w=401wt.eu-S1945929AbXBBPOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945929AbXBBPOA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 10:14:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945931AbXBBPN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 10:13:59 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:38783 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945929AbXBBPN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 10:13:59 -0500
Date: Fri, 2 Feb 2007 16:11:11 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Paul Rolland <rol@as2917.net>
cc: "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       "'Andrew Morton'" <akpm@osdl.org>,
       "'Jon Masters'" <jonathan@jonmasters.org>,
       "'Alexey Dobriyan'" <adobriyan@gmail.com>
Subject: RE: [PATCH] Ban module license tag string termination trick
In-Reply-To: <011601c746d9$dc5453b0$4b00a8c0@donald>
Message-ID: <Pine.LNX.4.61.0702021610510.26531@yvahk01.tjqt.qr>
References: <011601c746d9$dc5453b0$4b00a8c0@donald>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	0.0 UPPERCASE_25_50        message body is 25-50% uppercase
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 2 2007 15:53, Paul Rolland wrote:
>
>If that is really one important point, why not simply adding a :
>MODULE_IS_UNDER_GPL_LICENSE("yes|no")
>and a
>MODULE_IS_UNDER_GPL_LIKE_LICENSE("yes|no")
>
>or use 0 and 1 instead of yes and no, and thus clearly avoid all the
>C string mess ?

MODULE_IS_UNDER_GPL_LICENSE("yes\0 but only this .c file");


Jan
-- 
ft: http://freshmeat.net/p/chaostables/
