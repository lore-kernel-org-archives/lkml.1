Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282Ab0APAnV (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 19:43:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757766Ab0APAnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 19:43:20 -0500
Received: from mail.perches.com ([173.55.12.10]:1231 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754849Ab0APAnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 19:43:20 -0500
Subject: Re: [PATCH V2 (changelog update only)] scripts/get_maintainer.pl:
 Add --sections, print entire matched subsystem
From: Joe Perches <joe@perches.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B507B73.6000404@s5r6.in-berlin.de>
References: <1263408063.8011.116.camel@Joe-Laptop.home>
	 <20100114151254.72b57501.akpm@linux-foundation.org>
	 <1263519770.1903.49.camel@Joe-Laptop.home>
	 <4B507B73.6000404@s5r6.in-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jan 2010 16:43:18 -0800
Message-ID: <1263602598.15135.30.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-15 at 15:28 +0100, Stefan Richter wrote:
> Joe Perches wrote:
> > Sample output:
> > $ ./scripts/get_maintainer.pl --sections -f drivers/net/usb/smsc95xx.c
> > USB SMSC95XX ETHERNET DRIVER
> > M:Steve Glendinning <steve.glendinning@smsc.com>
> > L:netdev@vger.kernel.org
> > S:Supported
> > F:drivers/net/usb/smsc95xx.*
> > USB SUBSYSTEM
> > M:Greg Kroah-Hartman <gregkh@suse.de>
> > L:linux-usb@vger.kernel.org
> > W:http://www.linux-usb.org
> > T:quilt kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
> [...]

> $ ./scripts/get_maintainer.pl --sections -f drivers/net/usb/smsc95xx.c
> USB SMSC95XX ETHERNET DRIVER
>     M:Steve Glendinning <steve.glendinning@smsc.com>
>     L:netdev@vger.kernel.org
>     S:Supported
>     F:drivers/net/usb/smsc95xx.*
> 
> USB SUBSYSTEM
>     M:Greg Kroah-Hartman <gregkh@suse.de>
>     L:linux-usb@vger.kernel.org
>     W:http://www.linux-usb.org
>     T:quilt kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/

The MAINTAINERS file uses tab or space after "^[A-Z]:"
Perhaps that format should be kept.

I don't have a strong preference.

Anyone else?

