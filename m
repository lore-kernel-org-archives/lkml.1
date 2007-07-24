Return-Path: <linux-kernel-owner+w=401wt.eu-S1758489AbXGXQH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489AbXGXQH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 12:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752970AbXGXQHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 12:07:51 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:39881 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbXGXQHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 12:07:50 -0400
Date: Tue, 24 Jul 2007 18:09:33 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20070724160933.GH4074@enneenne.com>
References: <20070717180550.GA24759@enneenne.com> <1185197716.14697.244.camel@pmac.infradead.org> <20070724080013.GA22171@gundam.enneenne.com> <1185284942.14697.319.camel@pmac.infradead.org> <20070724143147.GE4074@enneenne.com> <1185288319.14697.330.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185288319.14697.330.camel@pmac.infradead.org>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH] LinuxPPS - definitive version
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2007 at 03:45:19PM +0100, David Woodhouse wrote:
> On Tue, 2007-07-24 at 16:31 +0200, Rodolfo Giometti wrote:
> > drivers/built-in.o: In function `sys_time_pps_fetch':
> > (.text+0x5f05e): undefined reference to `__udivdi3' 
> 
> Hm, not sure. Maybe put it back to uint32_t and then add another
> uint32_t of explicit padding, or maybe just cast it to uint32_t when you
> divide:
> 
> 	ticks += (uint32_t)to.nsec / (NSEC_PER_SEC/HZ);

Ok, padding data added. :)

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
