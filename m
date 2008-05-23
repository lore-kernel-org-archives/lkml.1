Return-Path: <linux-kernel-owner+w=401wt.eu-S1757279AbYEWQJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbYEWQJg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 12:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754014AbYEWQJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 12:09:29 -0400
Received: from vena.lwn.net ([206.168.112.25]:36844 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570AbYEWQJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 12:09:28 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       mchehab@infradead.org
Subject: Re: [PATCH] video4linux: Push down the BKL 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Fri, 23 May 2008 16:39:56 BST."
             <20080523163956.6e93746c@core> 
Date: Fri, 23 May 2008 10:09:28 -0600
Message-ID: <15168.1211558968@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> The problem is that currently they are almost all unsafe - I did a quick
> survey as part of the changes. Pushing it down to the video2_ioctl is a
> starting point, but the v4l layer is going to need a lot of love and its
> own gradual migration.

Agreed.
 
> Right now we've gone from BKL buried in fs to BKL at top of v4l layer
> which is indeed only a starting point. I'd assumed the same as you are
> think a new video_ioctl2 and switching drivers one by one (I was assuming
> adding video2_ioctl_unlocked())

It sound like we're thinking the same way, yes.  Except I'd pick the
long name for the one we want to get rid of :)

BTW, drop me a pointer if you'd like this series pulled into the
ever-growing bkl-removal tree.

jon
