Return-Path: <linux-kernel-owner+w=401wt.eu-S939435AbXG3UrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939435AbXG3UrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 16:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937223AbXG3UrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 16:47:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52278 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936910AbXG3UrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 16:47:03 -0400
Message-ID: <46AE4E29.7060402@zytor.com>
Date: Mon, 30 Jul 2007 13:46:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: bbpetkov@yahoo.de
CC: Xudong Guan <xudong.guan@gmail.com>, linux-kernel@vger.kernel.org,
       Chuck Ebbert <cebbert@redhat.com>
Subject: Re: 2.6.23-rc1: no setup signature found...
References: <20070726163053.GA4570@gollum.tnic> <46A8E3F9.5070809@zytor.com> <20070727013615.GC4570@gollum.tnic> <46A9753A.1010206@zytor.com> <20070729085059.GA10758@gollum.tnic> <20070729092402.GA2272@xguan-laptop> <20070729103706.GA16780@gollum.tnic> <46AC9B28.6060906@zytor.com> <20070729191528.GA5166@gollum.tnic> <46ADF02F.7010800@zytor.com> <20070730185359.GA4290@gollum.tnic>
In-Reply-To: <20070730185359.GA4290@gollum.tnic>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> 
> Hi,
> 
> i decided to do some cheating :) and skipped the breakpoint where it used to
> stop (0x40200). (by the way, hitting 'c' wouldn't continue at all and keep
> executing the same instruction over and over again). This time it seems it behaves as expected:
> 

Uhm, it looks to me that you ran qemu with the -kernel option again (I 
can tell because the dump exhibits a few bugs that are characteristic of 
the qemu loader.)  This makes qemu itself load the kernel and not rely 
on the boot loader that's on your bootloader.

I was expecting you to run "qemu -S -s -hda /dev/hda -snapshot", which 
you previously said when run (without the -S -s) options reproduced the 
problem.

After taking the dump, please do:

	delete
	c

... to verify the problem is reproduced.

Thanks,

	-hpa


