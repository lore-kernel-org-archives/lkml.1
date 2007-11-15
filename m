Return-Path: <linux-kernel-owner+w=401wt.eu-S1763343AbXKOKAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763343AbXKOKAT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 05:00:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756941AbXKOKAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 05:00:08 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:41071 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756495AbXKOKAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 05:00:06 -0500
Date: Thu, 15 Nov 2007 12:59:28 +0300
From: Alexey Dobriyan <adobriyan@sw.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: EIP is at device_shutdown+0x32/0x60
Message-ID: <20071115095928.GC6216@localhost.sw.ru>
References: <20071115091158.GB6216@localhost.sw.ru> <20071115014446.f943d835.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071115014446.f943d835.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2007 at 01:44:46AM -0800, Andrew Morton wrote:
> On Thu, 15 Nov 2007 12:11:58 +0300 Alexey Dobriyan <adobriyan@sw.ru> wrote:
> 
> > Three boxes rarely oops during reboot or poweroff with 2.6.24-rc2-mm1
> > (1) and during 2.6.24 cycle (2):
> > 
> > 	kernel_restart
> > 	sys_reboot
> > 	[garbage]
> > Code: 8b 88 a8 00 00 00 85 c9 74 04 89
> > EIP is at device_shutdown+0x32/0x60
> 
> Yes, all my test boxes did that - it's what I referred to in the releaee
> notes.  Greg is pondering the problem - seem he's the only person who
> cannot reproduce it ;)
> 
> But what does "during 2.6.24 cycle (2)" mean?  Some kernel other than
> 2.6.24-rc2-mm1 is crashing?

2.6.24-something also rarely crashes on reboot for me. In fact it can very
well be different crash. I never managed to catch oops message with mainline.
Netconsole doesn't show anything and replugging monitor cable also
doesn't help and bug dissapear if I try to catch it. :)

