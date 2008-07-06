Return-Path: <linux-kernel-owner+w=401wt.eu-S1758085AbYGFOh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085AbYGFOh3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 10:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756833AbYGFOhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 10:37:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:44599 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756309AbYGFOhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 10:37:21 -0400
Date: Sun, 6 Jul 2008 07:37:26 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Heikki Orsila <shdl@zakalwe.fi>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.26-rc9 load problem
Message-ID: <20080706073726.72074a3c@infradead.org>
In-Reply-To: <20080706142516.GA4379@zakalwe.fi>
References: <20080706142516.GA4379@zakalwe.fi>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jul 2008 17:25:16 +0300
Heikki Orsila <shdl@zakalwe.fi> wrote:

> Testing 2.6.26-rc9. Doing:
> 
> 	dd if=/dev/hda of=/dev/null bs=4096
> 
> causes the operating system to feel very unresponsible.
> Even the key repeat interval at tty1 is unpredictable.

Hi,

do you have an idea which version you tried last which didn't show this
behavior?

Also, can you try running latencytop to see if that shows where the
delays are?

(if rc8 was fine, 18ce3751ccd488c78d3827e9f6bf54e6322676fb is the most
likely suspect patch..

http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=18ce3751ccd488c78d3827e9f6bf54e6322676fb

can you see if reverting this helps?

-- 
If you want to reach me at my work email, use arjan@linux.intel.
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
