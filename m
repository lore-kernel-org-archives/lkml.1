Return-Path: <linux-kernel-owner+w=401wt.eu-S1763696AbYCGSmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763696AbYCGSmK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 13:42:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758365AbYCGSl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 13:41:57 -0500
Received: from mail.tmr.com ([64.65.253.246]:59674 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758343AbYCGSl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 13:41:56 -0500
Message-ID: <47D18D9B.9080907@tmr.com>
Date: Fri, 07 Mar 2008 13:46:51 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Matthew Hodgson <matthew@mxtelecom.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Toggling preemption on a running kernel
References: <47D086A4.6090103@mxtelecom.com>
In-Reply-To: <47D086A4.6090103@mxtelecom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Hodgson wrote:
> Hi,
> 
> I'm trying to compare the performance of some networking code 
> (throughput and latency when receiving various volumes of UDP streams) 
> between a preemptible and non-preemptible 2.6.24 kernel, and was 
> wondering if it is possible to temporarily disable preemption on a 
> running preemptible kernel.  Is it just a matter of loading a module 
> which calls preempt_enable() at load and preempt_disable() at unload - 
> or is that too naive?  Is there an existing way of doing this?
> 
That wouldn't get rid of all the code to support preempt, so it wouldn't 
be useful for comparing much of anything. I think you need to build two 
identical kernels here, with only one difference.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
