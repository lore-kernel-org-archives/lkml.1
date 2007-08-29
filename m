Return-Path: <linux-kernel-owner+w=401wt.eu-S1756737AbXH2CzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737AbXH2CzK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 22:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbXH2Cy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 22:54:58 -0400
Received: from mail.tmr.com ([64.65.253.246]:34845 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743AbXH2Cy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 22:54:58 -0400
Message-ID: <46D4DFDF.6090301@tmr.com>
Date: Tue, 28 Aug 2007 22:54:23 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Clements <paul.clements@steeleye.com>, linux-kernel@vger.kernel.org,
       david@dgreaves.com, Wouter Verhelst <w@uter.be>,
       Corey Minyard <cminyard@mvista.com>
Subject: Re: [PATCH 1/2] NBD: set uninitialized devices to size 0
References: <46CF101F.4050603@steeleye.com> <20070824164856.7024a95b.akpm@linux-foundation.org>
In-Reply-To: <20070824164856.7024a95b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 24 Aug 2007 13:06:39 -0400
> Paul Clements <paul.clements@steeleye.com> wrote:
> 
>> This fixes errors with utilities (such as LVM's vgscan) that try to scan 
>> all devices. Previously this would generate read errors when 
>> uninitialized nbd devices were scanned:
> 
> I somewhat randomly marked both these as 2.6.24 material.  If you think
> that was incorrect, please shout out.

I have the feeling that I mentioned nbd issues several releases ago, but 
never got to getting more info on reproducing them. I try not to submit 
bugs I can't reproduce, oftem they're my fault :-(


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
