Return-Path: <linux-kernel-owner+w=401wt.eu-S2992609AbXDLQA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992609AbXDLQA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 12:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992614AbXDLQA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 12:00:27 -0400
Received: from ns.theshore.net ([67.18.92.50]:39521 "EHLO www.theshore.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992609AbXDLQAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 12:00:14 -0400
X-Greylist: delayed 451 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Apr 2007 12:00:14 EDT
Message-ID: <461E55C6.1030905@theshore.net>
Date: Thu, 12 Apr 2007 11:52:38 -0400
From: "Christopher S. Aker" <caker@theshore.net>
User-Agent: Thunderbird 1.5.0.10 (Macintosh/20070221)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [Feature Request?] Inline compression of process core dumps
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've been trying to find a method for compressing process core dumps 
before they hit disk.

I ask because we've got some fairly large UML processes (1GB for some), 
and we're trying to capture dumps to help Jeff debug an evasive bug. 
Our systems use a small root partition and most of the other disk 
resources on the host are allocated towards the UMLs.

There are userspace solutions to this problem:  allowing the 
uncompressed core dump to spin out to disk and then coming in afterwards 
and doing the compression, or maybe even a compressed filesystem where 
the core dumps land, but I just thought I'd throw this out there since 
it seems it would be a useful feature :)

Thanks,
-Chris

