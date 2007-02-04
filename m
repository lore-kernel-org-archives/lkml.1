Return-Path: <linux-kernel-owner+w=401wt.eu-S1752535AbXBDUMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbXBDUMX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 15:12:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbXBDUMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 15:12:23 -0500
Received: from mail.tmr.com ([64.65.253.246]:33666 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536AbXBDUMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 15:12:21 -0500
Message-ID: <45C63E30.4010106@tmr.com>
Date: Sun, 04 Feb 2007 15:12:32 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [ANN] Userspace M-on-N threading model implementation. Alpha
   release.
References: <66910A579C9312469A7DF9ADB54A8B7D5C2B90@exchange.ZeugmaSystems.local>	 <45C362D2.2040407@tmr.com> <1170516376.3073.1015.camel@laptopd505.fenrus.org>
In-Reply-To: <1170516376.3073.1015.camel@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
>> Because user threading can avoid context switches, there will always be 
>> cases where it will outperform o/s threads for hardware reasons.
> 
> actually.. switching from one "real" thread to another in Linux is not
> an actual context switch in the hardware sense... at least this part of
> your argument seems to be incorrect ;)
> 
How does that work? Switching between kernel threads requires going into 
the kernel, user level thread switches are all done in user mode.

Do you have some way to change o/s threads w/o going into the kernel?

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
