Return-Path: <linux-kernel-owner+w=401wt.eu-S1761338AbXIUPjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761338AbXIUPjB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 11:39:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759487AbXIUPix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 11:38:53 -0400
Received: from zcars04f.nortel.com ([47.129.242.57]:36976 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758997AbXIUPiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 11:38:52 -0400
Message-ID: <46F3E584.4020301@nortel.com>
Date: Fri, 21 Sep 2007 09:38:44 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: question on kernel rwsem behaviour
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Sep 2007 15:38:48.0465 (UTC) FILETIME=[80B5E810:01C7FC65]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi all,

I just had a quick question on read-write semaphore semantics.  Suppose 
someone holds a sema for reading, then someone else tries to aquire it 
for writing, and blocks.  Finally, a third code path tries to aquire it 
for reading.

Does this third code path get the sema, or does it wait for the writer?

Based on looking at the implementation it seems like it waits, but I'd 
like to confirm that.

Thanks,

Chris
