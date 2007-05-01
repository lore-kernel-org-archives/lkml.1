Return-Path: <linux-kernel-owner+w=401wt.eu-S1161801AbXEATLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161801AbXEATLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 15:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161800AbXEATLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 15:11:17 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4395 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161802AbXEATLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 15:11:16 -0400
Date: Tue, 1 May 2007 20:10:56 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-pcmcia@lists.infradead.org
Subject: Re: pcmcia ioctl removal
Message-ID: <20070501191056.GC19872@flint.arm.linux.org.uk>
Mail-Followup-To: Jan Engelhardt <jengelh@linux01.gwdg.de>,
	"Robert P. J. Day" <rpjday@mindspring.com>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pcmcia@lists.infradead.org
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <20070501084623.GB14364@infradead.org> <Pine.LNX.4.64.0705010514300.9162@localhost.localdomain> <Pine.LNX.4.61.0705011202510.18504@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0705011202510.18504@yvahk01.tjqt.qr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 12:12:36PM +0200, Jan Engelhardt wrote:
> init/obsolete.c:
> static __init int obsolete_init(void)
> {
> 	printk("\e[1;31m""
> 
> The following stuff is gonna get removed \e[5;37m SOON: \e[0m
> 	- cardmgr
> 	- foobar
> 	- bweebol
> 
> ");
> 	schedule_timeout(3 * HZ);
> 	return;
> }

The kernel console isn't VT102 compatible.  It doesn't understand any
escape codes, at all.  Neither does sysklogd.  So the above will just
end up as rubbish on your console.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
