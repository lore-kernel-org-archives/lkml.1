Return-Path: <linux-kernel-owner+w=401wt.eu-S1755483AbXGGNYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbXGGNYM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 09:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753699AbXGGNX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 09:23:58 -0400
Received: from main.gmane.org ([80.91.229.2]:54742 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753680AbXGGNX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 09:23:57 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Leroy van Logchem <leroy.vanlogchem@gmail.com>
Subject: Re: Understanding I/O behaviour
Date: Sat, 7 Jul 2007 13:23:47 +0000 (UTC)
Message-ID: <loom.20070707T151648-630@post.gmane.org>
References: <468D832B.4060002@shaw.ca> <197707.68164.qm@web32604.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 145.9.190.39 (Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.4) Gecko/20070515 Firefox/2.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>  I am just now playing with dirty_ratio. Anybody knows what the lower
> limit is? "0" seems acceptabel, but does it actually imply "write out
> immediatelly"?

You should "watch -n 1 cat /proc/meminfo" and monitor the Dirty and Writeback
while lowering the amount the kernel may keep dirty. The solution we are hoping
for is are the per device dirty throttling -v7 patches.

-- 
Leroy

