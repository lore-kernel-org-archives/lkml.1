Return-Path: <linux-kernel-owner+w=401wt.eu-S1751700AbXCQVju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbXCQVju (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 17:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbXCQVjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 17:39:49 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:51751 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbXCQVjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 17:39:49 -0400
Date: Sat, 17 Mar 2007 15:39:35 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: SATA problems in 2.6.20.3
In-reply-to: <fa.+a98F7bGu4aNILT+hygbZ2RsPuE@ifi.uio.no>
To: Christian <christiand59@web.de>
Cc: linux-kernel@vger.kernel.org
Message-id: <45FC6017.7010704@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.lqWgqhKIlhgG3TXcvhBc/T7bPFE@ifi.uio.no>
 <fa.+a98F7bGu4aNILT+hygbZ2RsPuE@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christian wrote:
> I'm seeing the same here since a few days. Before it worked great (even with 
> NCQ). I've been getting those messages since 2.6.21-rc3-mm1 and with the 
> latest Ubuntu feisty kernel (2.6.20-11-generic #2 SMP Thu Mar 15 03:43:56 UTC 
> 2007 x86_64 GNU/Linux)
> 
> System is Athlon64 X2, Nforce4, 3x Samsung SATA II NCQ discs.

Can you try 2.6.21-rc4? There was a change that went in between rc3 and 
rc4 to revert a previous change which seemed to be problematic.

As far as 2.6.20, I'm somewhat tempted to submit this patch to -stable:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5e5c74a5e11d1e2a99d03132cc6c4455016db6c2

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

