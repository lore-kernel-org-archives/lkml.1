Return-Path: <linux-kernel-owner+w=401wt.eu-S1760405AbXEPLDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760405AbXEPLDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 07:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757681AbXEPLDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 07:03:10 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51307 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757408AbXEPLDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 07:03:09 -0400
Date: Wed, 16 May 2007 12:02:38 +0100 (BST)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Al Viro <viro@ftp.linux.org.uk>
cc: Manu Abraham <abraham.manu@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] em28xx and ivtv should depend on PCI
In-Reply-To: <20070516012254.GF4095@ftp.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0705161144520.19892@pentafluge.infradead.org>
References: <E1Ho2p6-0003Tt-B7@ZenIV.linux.org.uk> <464A4163.7090509@gmail.com>
 <20070516012254.GF4095@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 16 May 2007, Al Viro wrote:

>>> +	depends on VIDEO_V4L1 && I2C && PCI
>>
>> Err .. why would a USB device need to be depend on PCI ?
>
> Because video-buf.c does.  And VIDEO_EM28XX selects it.

There are already two patches fixing the broken dependencies for ivtv and 
em28xx on my -git tree:

http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;h=1cf15bd2c8606e232d4c29273f8d05fcd47cc0fd
http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;h=42aadebe90d9bc18a6753be45ed878b07de4c560

I've already asked Linus to pull it:

http://lkml.org/lkml/2007/5/13/100


-- 
Cheers,
Mauro Carvalho Chehab
http://linuxtv.org
mchehab@infradead.org
