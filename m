Return-Path: <linux-kernel-owner+w=401wt.eu-S1759976AbYBRQMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759976AbYBRQMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 11:12:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757538AbYBRQLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 11:11:48 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55461 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198AbYBRQLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 11:11:48 -0500
Date: Mon, 18 Feb 2008 13:11:25 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Bongani Hlope <bonganilinux@mweb.co.za>
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc[12] Video4Linux Bttv Regression
Message-ID: <20080218131125.2857f7c7@gaivota>
In-Reply-To: <200802171036.19619.bonganilinux@mweb.co.za>
References: <200802171036.19619.bonganilinux@mweb.co.za>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.7; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Feb 2008 10:36:19 +0200
Bongani Hlope <bonganilinux@mweb.co.za> wrote:

> The bttv driver seems to be experiencing problems in the 2.6.25-rcX kernels. I 
> have the divided by error that  Robert Fitzsimons has already reported (I'll 
> test his patch and see if it fixes it for me) and I have the following Oops 
> when I try to use the radio:

Have you tested Robert's patch?

I can't see anything wrong on bttv_g_tuner lock. I suspect that the divide
error caused some bad effects at some data on bttv.

I've already applied his fix to my -git tree:

http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git

Hopefully, Linus will pull soon the fixes there.


Cheers,
Mauro
