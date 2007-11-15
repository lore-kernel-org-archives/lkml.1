Return-Path: <linux-kernel-owner+w=401wt.eu-S1763420AbXKOJqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763420AbXKOJqM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 04:46:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757118AbXKOJp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 04:45:58 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46736 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756412AbXKOJp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 04:45:57 -0500
Date: Thu, 15 Nov 2007 01:44:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: EIP is at device_shutdown+0x32/0x60
Message-Id: <20071115014446.f943d835.akpm@linux-foundation.org>
In-Reply-To: <20071115091158.GB6216@localhost.sw.ru>
References: <20071115091158.GB6216@localhost.sw.ru>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007 12:11:58 +0300 Alexey Dobriyan <adobriyan@sw.ru> wrote:

> Three boxes rarely oops during reboot or poweroff with 2.6.24-rc2-mm1
> (1) and during 2.6.24 cycle (2):
> 
> 	kernel_restart
> 	sys_reboot
> 	[garbage]
> Code: 8b 88 a8 00 00 00 85 c9 74 04 89
> EIP is at device_shutdown+0x32/0x60

Yes, all my test boxes did that - it's what I referred to in the releaee
notes.  Greg is pondering the problem - seem he's the only person who
cannot reproduce it ;)

But what does "during 2.6.24 cycle (2)" mean?  Some kernel other than
2.6.24-rc2-mm1 is crashing?

