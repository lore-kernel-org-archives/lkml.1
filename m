Return-Path: <linux-kernel-owner+w=401wt.eu-S1753510AbXCYMzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbXCYMzN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 08:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753508AbXCYMzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 08:55:13 -0400
Received: from dd3532.kasserver.com ([81.209.188.70]:36951 "EHLO
	dd3532.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510AbXCYMzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 08:55:12 -0400
X-Greylist: delayed 2000 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Mar 2007 08:55:12 EDT
Message-ID: <46066970.20802@helmutauer.de>
Date: Sun, 25 Mar 2007 14:22:08 +0200
From: Helmut Auer <vdr@helmutauer.de>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Kernel 2.6.20 takes a long time to load
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello List,

The kernel 2.6.20 makes a long delay during booting ( about 15 seconds ) after showing:

NET: Registered protocol family 2

then it goes along with:

IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
TCP established hash table entries: 8192 (order: 4, 98304 bytes)
...

I am using the kernel parameter lpj to avoid calculating processor speed during kernel load.
If I do not use the lpj parameter, the detection of cpu speed takes about 10 seconds, but then 
there is no delay after:
NET: Registered protocol family 2

Any hints what I can try to get a fast booting kernel ?
I am using 2.6.20 with some gentoo patches ( plain 2.6.20-4 has the same problem ).

My .config is here:
http://www.helmutauer.de/.config-2.6.20.3.gz

-- 
Helmut Auer, helmut@helmutauer.de
