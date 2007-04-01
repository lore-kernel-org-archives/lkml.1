Return-Path: <linux-kernel-owner+w=401wt.eu-S933856AbXDATC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933856AbXDATC3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 15:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933908AbXDATC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 15:02:29 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:57750 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933856AbXDATC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 15:02:28 -0400
Date: Sun, 1 Apr 2007 21:02:12 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Edgardo Hames <ehames@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Rebuilding and checksumming the Linux kernel
In-Reply-To: <478c16ae0704011156u5a34ae96lfd88a6da16d5726a@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0704012101430.16977@yvahk01.tjqt.qr>
References: <478c16ae0704011156u5a34ae96lfd88a6da16d5726a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 1 2007 15:56, Edgardo Hames wrote:
>
> I'm working on a project with teams spread across the world and we all
> work on the same repository patching the kernel and then integrating
> into a common main branch. Even though we label the source code, we
> would like to make sure that we are all building the same kernel by
> running md5sum on the resulting binary.

If you just want to make sure that interfaces match,
CONFIG_MODULE_SRCVERSION_ALL should be doing the right thing.


Jan
-- 
