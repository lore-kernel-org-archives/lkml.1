Return-Path: <linux-kernel-owner+w=401wt.eu-S1751877AbXCTRoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbXCTRoP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 13:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895AbXCTRoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 13:44:15 -0400
Received: from zrtps0kn.nortel.com ([47.140.192.55]:52768 "EHLO
	zrtps0kn.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbXCTRoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 13:44:14 -0400
Message-ID: <46001D5C.3020406@nortel.com>
Date: Tue, 20 Mar 2007 11:43:56 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: how to purposfully fragment memory?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Mar 2007 17:44:00.0370 (UTC) FILETIME=[57BBE520:01C76B17]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I'm trying to test code paths dealing with fragmented memory, so I'd 
like to have a simple way to cause fragmented memory in the kernel.  Is 
there any API in the kernel that would let me allocate two contiguous 
pages, then free one of them?


I tried the following, but it triggers an oops in free_page():

unsigned long addr =
	__get_free_pages(GFP_KERNEL|__GFP_NORETRY|__GFP_NOWARN, 1);
if (!addr)
	break;
free_page(addr+4096);


Thanks,

Chris
