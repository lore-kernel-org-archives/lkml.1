Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbYGWRAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbYGWRAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 13:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbYGWRAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 13:00:04 -0400
Received: from kruk.ds2.uw.edu.pl ([193.0.110.20]:57606 "EHLO mail.wijata.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914AbYGWRAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 13:00:01 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jul 2008 13:00:01 EDT
Message-ID: <488761F0.4040906@wijata.com>
Date: Wed, 23 Jul 2008 18:53:04 +0200
From: Rafal Wijata <devnull@wijata.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Odd swapping issue
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It happened twice recently(within one week), therefore I'm posting here.

32bit Fedora7, 2.6.23.17-88.fc7PAE, 16G ram, 12G swap, 2*dualXeon

My machine went sluggish. Tried to debug it, and observed, that free 
ram(the unused one) was increasing while swap usage was increasing as 
well. It stopped after whole swap partition was used. Then it came back 
normal. Required processes were brought back to ram and server become 
responsible again.

Now the most strange thing is that there was 5G free(unused) ram, during 
those few minutes it growed to 12G! In the very same time swap usage 
increased from ~4G to 12G.
This is irrational to me. Can anybody explain? How to prevent?

vm.swappiness was decreased to 30, to avoid excessive swap usage, but no 
avail.

It's application and nfs server/client if it matters. During that 
"memory sweep" I observed many nfsd processes(kernel threads?) in D state.
