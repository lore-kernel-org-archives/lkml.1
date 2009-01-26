Return-Path: <linux-kernel-owner+w=401wt.eu-S1752071AbZAZPuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbZAZPuP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 10:50:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbZAZPuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 10:50:00 -0500
Received: from zcars04e.nortel.com ([47.129.242.56]:59037 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbZAZPt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 10:49:59 -0500
X-Greylist: delayed 701 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Jan 2009 10:49:58 EST
Message-ID: <497DD8E5.1040305@nortel.com>
Date: Mon, 26 Jan 2009 09:38:13 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: marching through all physical memory in software
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jan 2009 15:38:14.0712 (UTC) FILETIME=[1A3E5B80:01C97FCC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Someone is asking me about the feasability of "scrubbing" system memory 
by accessing each page and handling the ECC faults.

The range of PAGE_OFFSET to "high_memory" should get me all of the 
kernel memory area, but what about all the memory set aside for 
userspace (which may not be contiguous)?  Is there any straightforward 
way to march through this memory?

I suppose I'm looking for something like walk_page_range(), but for 
physical memory rather than virtual.

Thanks,

Chris
