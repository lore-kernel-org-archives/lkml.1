Return-Path: <linux-kernel-owner+w=401wt.eu-S1762052AbXGTD3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762052AbXGTD3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 23:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753973AbXGTD3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 23:29:03 -0400
Received: from mail.tmr.com ([64.65.253.246]:48371 "EHLO posidon.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753918AbXGTD3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 23:29:01 -0400
Message-ID: <46A02BFB.3090500@tmr.com>
Date: Thu, 19 Jul 2007 23:28:59 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: Where did KVM go in 2.6.22-git9?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I just built a 2.6.22-git9 kernel, and when I run oldconfig it (a) sets 
the processor type to pentium-pro, and (b) the KVM stuff simply isn't in 
the config. Before I spend a lot of time on this, was it disabled 
temporarily for some reason, or is it a known bug, or ???

Processor is a Core2 E6600, and the starting config has KVM.

Strong suggestion: put KVM in processor type and options, and if the CPU 
type selected supports the feature, let the builder turn it on in one 
place and have Kconfig turn on whatever voodoo is needed to allow it, 
rather than have people trying to find out what depends have changed 
with each release. I see KVm depends on X86_CMPXCHG64 which simply 
doesn't seem to be defined directly anywhere.

Going back to 2.6.21.6 until whatever changed is at least documented.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

