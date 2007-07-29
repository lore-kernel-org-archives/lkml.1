Return-Path: <linux-kernel-owner+w=401wt.eu-S1759185AbXG2AEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759185AbXG2AEh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 20:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758155AbXG2AE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 20:04:29 -0400
Received: from mail07.syd.optusnet.com.au ([211.29.132.188]:36961 "EHLO
	mail07.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758145AbXG2AE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 20:04:28 -0400
From: Con Kolivas <kernel@kolivas.org>
To: ck@vds.kolivas.org
Subject: Re: [ck] Re: Linus 2.6.23-rc1
Date: Sun, 29 Jul 2007 10:03:52 +1000
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       jos poortvliet <jos@mijnkamer.nl>, Michael Chang <thenewme91@gmail.com>,
       Kasper Sandberg <lkml@metanurb.dk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <200707282128.39906.jos@mijnkamer.nl> <alpine.LFD.0.999.0707281313570.3442@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707281313570.3442@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707291003.52817.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Interesting... Trying to avoid reading email but with a flooded inbox it's 
quite hard to do.

A lot of useful discussion seems to have generated in response to people's 
_interpretation_ of my interview rather than what I actually said. For 
example, everyone seems to think I quit because CFS was chosen over SD (hint: 
it wasn't). Since it's generating good discussion I'll otherwise leave it as 
is.


As a parting gesture; a couple of hints for CFS. 

Any difference in behaviour between CFS and SD since they both aim for 
fairness would come down to the way they interpret fair. Since CFS accounts 
sleep time whereas SD does not, that would be the reason.

As for volanomark regressions, they're always the sched_yield implementation. 
SD addressed a similar regression a few months back.

Good luck.

-- 
-ck
