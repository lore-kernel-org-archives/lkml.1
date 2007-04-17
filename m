Return-Path: <linux-kernel-owner+w=401wt.eu-S1752540AbXDQIG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbXDQIG6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 04:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbXDQIG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 04:06:58 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:33635 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540AbXDQIG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 04:06:57 -0400
Date: Tue, 17 Apr 2007 10:05:32 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 13/16] show-pipesize-in-stat.diff
In-Reply-To: <461331BB.6000202@cosmosbay.com>
Message-ID: <Pine.LNX.4.61.0704070034540.6042@yvahk01.tjqt.qr>
References: <461331BB.6000202@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 04 Apr 2007 07:03:55 +0200, Eric Dumazet wrote:
>find net | xargs grep -n SIOCINQ
>I suspect you will find unix_ioctl() in net/unix/af_unix.c ?
>BTW, my patch only worked for pipes, not fifos. Ie pipe(), not 
>open("/some/fifo.p", ...)

Thanks for your patch. There is a question however; why don't you do
  stat->size = pipe_size(inode);
in generic_fill_attr (perhaps wrapped into an if(S_ISFIFO))?


Regards,
Jan
-- 
