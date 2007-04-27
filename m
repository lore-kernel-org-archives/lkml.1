Return-Path: <linux-kernel-owner+w=401wt.eu-S1757346AbXD0Vfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346AbXD0Vfv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 17:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757351AbXD0Vft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 17:35:49 -0400
Received: from mail.tmr.com ([64.65.253.246]:48774 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757346AbXD0Ve4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 17:34:56 -0400
Message-ID: <46326CDD.9040502@tmr.com>
Date: Fri, 27 Apr 2007 17:36:29 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Stephen.Clark@seclark.us
CC: Jeff Garzik <jeff@garzik.org>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org> <20070426040806.GJ3468@stusta.de> <4630E00B.3090502@tmr.com> <4630E9C8.5060000@garzik.org> <4630FA27.1090203@seclark.us>
In-Reply-To: <4630FA27.1090203@seclark.us>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Clark wrote:

> If hardware worked in the previous version of the kernel can't users expect
> the same hardware to work in this kernel?
> 
Failure of that assumption is the heart of the whole "regression" 
discussion. It's not limited to hardware, kernel security might be an 
issue, some network protocols might work faster and less reliably, etc.

Kernel behavior changes sometimes totally break user software which 
makes unwarranted assumptions. That's not a regression, although users 
may see it that way. When a change in fork() changed the 
child-runs-first behavior, many programs broke, as was true with 
threading changes. Bad reliability is the reward for bad code, but if a 
kernel change makes that obvious some people think it's a regression.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
