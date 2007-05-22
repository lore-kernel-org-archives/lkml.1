Return-Path: <linux-kernel-owner+w=401wt.eu-S1759837AbXEVU1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759837AbXEVU1M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 16:27:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757076AbXEVU07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 16:26:59 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:38952 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756687AbXEVU06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 16:26:58 -0400
Date: Tue, 22 May 2007 22:18:41 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Al Viro <viro@ftp.linux.org.uk>
cc: Ray Lee <ray-lk@madrabbit.org>, Andrey Borzenkov <arvidjaar@mail.ru>,
       Uwe Bugla <uwe.bugla@gmx.de>, Ken Chen <kenchen@google.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: bug in 2.6.22-rc2: loop mount limited to one single iso image
In-Reply-To: <20070520062816.GA4095@ftp.linux.org.uk>
Message-ID: <Pine.LNX.4.61.0705222217300.4452@yvahk01.tjqt.qr>
References: <464F42F3.1080300@madrabbit.org> <20070519191751.E51233A23A2@muan.mtu.ru>
 <200705200124.13026.uwe.bugla@gmx.de> <200705200845.43621.arvidjaar@mail.ru>
 <2c0942db0705192316s2682807chd23df6f4de29edcb@mail.gmail.com>
 <20070520062816.GA4095@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 20 2007 07:28, Al Viro wrote:
>On Sat, May 19, 2007 at 11:16:59PM -0700, Ray Lee wrote:
>> Ken? Ball's in your court. As the patch isn't providing a killer
>> feature for 2.6.22, I'd suggest just reverting it for now until the
>> issues are ironed out.
>
>Hold it.  The real question here is which logics do we want there.
>IOW, and how many device nodes do we want to appear and _when_ do
>we want them to appear?

"min_loop" (max_loop?) nodes should appear (but without a backing
gendisk), and when they are opened, they should get their gendisk
allocated and assigned.



	Jan
-- 
