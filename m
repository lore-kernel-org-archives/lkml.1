Return-Path: <linux-kernel-owner+w=401wt.eu-S1761581AbXEJLqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761581AbXEJLqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 07:46:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761284AbXEJLpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 07:45:14 -0400
Received: from 81-174-11-161.f5.ngi.it ([81.174.11.161]:45966 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761605AbXEJLpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 07:45:11 -0400
Date: Thu, 10 May 2007 13:45:03 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linuxpps@ml.enneenne.com
Message-ID: <20070510114502.GJ11009@enneenne.com>
References: <20070502193314.GA23367@enneenne.com> <20070510002740.c4350813.akpm@linux-foundation.org> <20070510105837.GB979@enneenne.com> <20070510.040152.39159048.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510.040152.39159048.davem@davemloft.net>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 1/1] LinuxPPS: Pulse per Second support for Linux
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 04:01:52AM -0700, David Miller wrote:
> 
> It's not OK, please use the generic netlink interface and as
> such you will not need to allocate any numbers at all.
> 
> Documentation/networking/generic_netlink.txt gives a link
> to some infomration on this topic.

If I well understand doing like this means that I have to modify also
userland API, is that true?

I know that you are forcing in using this new interface for new kernel
projects, but if I have to change my code I need also change NTPD
related code and this is frustrating. I have to interact with both
kernel developers and NTPD ones... :)

It could be acceptable let me use id "20" (or just another number) to
allow Andrew Morton and other LinuxPPS users to test this new support?
Please, consider that this is not a new project, it was developed
since 2005 when this new interface was not available.

Thanks for your attention,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
