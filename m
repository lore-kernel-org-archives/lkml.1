Return-Path: <linux-kernel-owner+w=401wt.eu-S1756521AbYEZVOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521AbYEZVOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 17:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbYEZVOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 17:14:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53884 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922AbYEZVOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 17:14:36 -0400
Date: Mon, 26 May 2008 18:14:06 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Andy Walls <awalls@radix.net>, Douglas Landgraf <dougsland@gmail.com>,
       Alan Cox <alan@redhat.com>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] video4linux: Push down the BKL
Message-ID: <20080526181406.40f9e082@gaivota>
In-Reply-To: <200805261846.35758.hverkuil@xs4all.nl>
References: <20080522223700.2f103a14@core>
	<20080523090919.GA31575@devserv.devel.redhat.com>
	<20080526133457.6f892af9@gaivota>
	<200805261846.35758.hverkuil@xs4all.nl>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Could you send this patch to the ML for people to review and for Andy
> > to port it to cx18?
> 
> Unless there is an objection, I would prefer to take Douglas' patch and 
> merge it into the v4l-dvb ivtv driver myself. There were several things 
> in the patch I didn't like, but I need to 'work' with it a bit to see 
> how/if it can be done better.

I didn't analyze his patch in detail. However, it is a starting point
for you to work with. I'm sure you can improve it if needed.

> I can work on it tonight and tomorrow. Hopefully it is finished by then. 
> I can move the BKL down at the same time for ivtv. It is unlikely that 
> I will have time to do cx18 as well as I'm abroad from Wednesday until 
> Monday, but I think Andy can do that easily based on the ivtv changes.

This strategy seems OK to me.


Cheers,
Mauro
