Return-Path: <linux-kernel-owner+w=401wt.eu-S933917AbXDATFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933917AbXDATFp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 15:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933916AbXDATFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 15:05:45 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:58980 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933917AbXDATFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 15:05:44 -0400
Date: Sun, 1 Apr 2007 21:04:09 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Willy Tarreau <w@1wt.eu>
cc: Pedram M <pmessri@gmail.com>, kernel-janitors@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: my first janitorial
In-Reply-To: <20070401061707.GB943@1wt.eu>
Message-ID: <Pine.LNX.4.61.0704012103330.16977@yvahk01.tjqt.qr>
References: <9c9aa5d00703310639q68fa5d19k4d8e3bfb56b1fa6@mail.gmail.com>
 <9c9aa5d00703312224t1948b24bhe34199f19cbda4fb@mail.gmail.com>
 <20070401061707.GB943@1wt.eu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 1 2007 08:17, Willy Tarreau wrote:
>
>   - your patch was cut and cannot apply to anything. A proper patch starts
>     with line beginning with "---" line, followed by a line with "+++",
>     both indicating the file your patch is supposed to apply to. Make your
>     patch with one level directory for the kernel so that it can apply with
>     "patch -p1". For instance:
>
>        $ diff -u linux-2.6.20/Makefile linux-2.6.20-mine/Makefile
>
>     Another solution is to use '.' as the directory, in order to add one
>     directory level for "patch -p1" to be happy :
>
>        $ diff -u ./Makefile.orig ./Makefile

Suggesting quilt.



Jan
-- 
