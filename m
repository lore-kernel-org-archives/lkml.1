Return-Path: <linux-kernel-owner+w=401wt.eu-S1946548AbXD3SSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946548AbXD3SSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 14:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946554AbXD3SSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 14:18:24 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:56672 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946548AbXD3SSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 14:18:23 -0400
Date: Mon, 30 Apr 2007 20:16:41 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Latchesar Ionkov <lionkov@gmail.com>
cc: Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>,
       V9FS Developers <v9fs-developer@lists.sourceforge.net>
Subject: Re: [PATCH] 9p: create separate 9p client interface
In-Reply-To: <f158dc670704300832l36889bf2kfa4480addbe8cfb2@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0704302015300.29151@yvahk01.tjqt.qr>
References: <f158dc670704300832l36889bf2kfa4480addbe8cfb2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 30 2007 09:32, Latchesar Ionkov wrote:
Hi!

> --- a/fs/9p/Makefile
> +++ b/fs/9p/Makefile
> @@ -3,8 +3,8 @@ obj-$(CONFIG_9P_FS) := 9p.o
> 9p-objs := \
> trans_fd.o \
> mux.o \
> -	fcall.o \
> 	conv.o \
> +	clnt.o \

Do you pay by the letter, or why is not the source file called client.c? :)

(BTW, patch is whitespace-broken.)


Jan
-- 
