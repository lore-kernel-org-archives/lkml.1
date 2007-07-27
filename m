Return-Path: <linux-kernel-owner+w=401wt.eu-S935034AbXG0PKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935034AbXG0PKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 11:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934197AbXG0PKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 11:10:10 -0400
Received: from jade.padinet.com ([202.6.233.250]:4206 "HELO owl.postpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933353AbXG0PKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 11:10:08 -0400
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Jul 2007 11:10:06 EDT
Date: Fri, 27 Jul 2007 22:03:44 +0700
From: adi <adi@postpi.com>
To: Clemens Koller <clemens.koller@anagramm.de>
Cc: Mario Doering <mario@dedenet.de>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: D-Link DFE-580TX 4 port NIC problems
Message-ID: <20070727150344.GA9071@postpi.com>
References: <20070509120142.2305a1d1@snibbles.dedenet.de> <20070509032700.569789a0.akpm@linux-foundation.org> <20070727113044.76630826@snibbles.dedenet.de> <46A9E029.4080200@anagramm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A9E029.4080200@anagramm.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2007 at 02:08:09PM +0200, Clemens Koller wrote:
> Can you try the latest kernel to see if the same problem
> persists?
> Is there any kernel version where it was working fine?

In my case, this is 'problem' occur when I do run snmpd on
the same machine, and I saw that snmpd doing something
like this:

    ...
    } else if (ioctl(fd, SIOCDEVPRIVATE, &ifr) >= 0) {
       new_ioctl_nums  = 1;
    }
    ....

That cause sundance printing a lot of debug messages (i.e netdev_ioctl()
in sundance.c) .. periodically, as long as snmpd running :-)

Regards,

P.Y. Adi Prasaja

