Return-Path: <linux-kernel-owner+w=401wt.eu-S1752442AbYFAV5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442AbYFAV5m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 17:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbYFAV5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 17:57:21 -0400
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:53551
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751967AbYFAV5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 17:57:20 -0400
Cc: linux-kernel@vger.kernel.org
Message-Id: <E234E250-922E-45F6-B01E-0B3CDC80A8ED@it-loops.com>
From: Guntsche Michael <mike@it-loops.com>
To: Arjan Ven van de <arjan@infradead.org>
In-Reply-To: <F2473A1D-E4F5-4B9D-9538-B122553E1011@it-loops.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v924)
Subject: Re: 2.6.25.x: Wrong CPU frequency (cpufreq table) with p4-clockmod
Date: Sun, 1 Jun 2008 23:57:14 +0200
References: <12C649C0-4BEF-41F1-B738-8C8CEF8AEBB8@it-loops.com> <20080530065717.44cf7414@infradead.org> <F2473A1D-E4F5-4B9D-9538-B122553E1011@it-loops.com>
X-Mailer: Apple Mail (2.924)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 30, 2008, at 16:07, Guntsche Michael wrote:

>
> I am most interested in keeping the temperature of my CPU down,  
> which means slower fans, which means less noise.
> The main "problem" I have is that I do not know if this is a simple  
> display issue or if I am having a more fundamental problem here.

Just FYI I found out the cause of my problem.

Reverting http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=ed9cbcd40004904dbe61ccc16d6106a7de38c998 
  this patch resultsin the correct numbers for me.

<cpuinfo snip>
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 15
model		: 1
model name	: Intel(R) Pentium(R) 4 CPU 1.70GHz
stepping	: 2
cpu MHz		: 637.500
<snip>

This patch was reverted because other people seem to have problems  
with it, reverting the revert does not look like a good idea either.
But since I know now, that this is just a "display" problem and  
everything is working otherwise, I'll just patch this locally for my  
machine here.

Kind regards,
Michael
