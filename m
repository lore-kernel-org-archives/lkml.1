Return-Path: <linux-kernel-owner+w=401wt.eu-S1758481AbXELLmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758481AbXELLmO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 07:42:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756508AbXELLl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 07:41:59 -0400
Received: from main.gmane.org ([80.91.229.2]:48878 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756501AbXELLl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 07:41:58 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jindrich Makovicka <makovick@gmail.com>
Subject: Re: [PATCH] Add LZO1X compression support to the kernel
Date: Sat, 12 May 2007 13:41:44 +0200
Message-ID: <20070512134144.5bb29544@holly>
References: <1785450541@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: kmlinux.fjfi.cvut.cz
X-Newsreader: Claws Mail 2.9.1 (GTK+ 2.10.12; i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 May 2007 12:41:03 +0200
devzero@web.de wrote:

> oh - and think of linux software suspend.
> take a notebook with 2 GB of ram - that takes a while to write that
> to disk and read that back again. using lzo compression for this may
> probably halve the time for suspend/resume

There were already some attempts on merging of the lzf algorithm:

http://lkml.org/lkml/2006/6/26/215

Also, ffmpeg/libavcodec contains a much cleaner implementation of LZO
decompressor, with comparable performance (but no compressor yet I am
afraid).

-- 
Jindrich Makovicka

