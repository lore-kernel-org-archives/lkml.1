Return-Path: <linux-kernel-owner+w=401wt.eu-S935862AbZAPPYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935862AbZAPPYe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 10:24:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756069AbZAPPYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 10:24:11 -0500
Received: from p02c12o141.mxlogic.net ([208.65.145.74]:53090 "EHLO
	p02c12o141.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758918AbZAPPYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 10:24:09 -0500
Message-ID: <4970A696.9070307@steeleye.com>
Date: Fri, 16 Jan 2009 10:24:06 -0500
From: Paul Clements <paul.clements@steeleye.com>
User-Agent: Swiftdove 2.0.0.9 (X11/20071116)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: nbd: add locking to nbd_ioctl
References: <20090116115512.GA10771@elf.ucw.cz>
In-Reply-To: <20090116115512.GA10771@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jan 2009 15:24:06.0479 (UTC) FILETIME=[7886C5F0:01C977EE]
X-Spam: [F=0.2000000000; S=0.200(2008120801)]
X-MAIL-FROM: <paul.clements@steeleye.com>
X-SOURCE-IP: [207.43.68.209]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> The code was written with "oh big kernel lock, please protect me from
> all the evil" mentality: it does not locks its own data structures, it
> just hopes that big kernel lock somehow helps.
> 
> It does not. (My fault).
> 
> So this uses tx_lock to protect data structures from concurrent use
> between ioctl and worker threads.

What is the particular problem that this fixes? I thought we had already 
been careful to take tx_lock where necessary to protect data structures. 
   Perhaps there is something I missed?

--
Paul
