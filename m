Return-Path: <linux-kernel-owner+w=401wt.eu-S1753508AbXDZWac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbXDZWac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 18:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbXDZWac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 18:30:32 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:50547 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139AbXDZWaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 18:30:25 -0400
Message-ID: <46312779.4060405@gmail.com>
Date: Fri, 27 Apr 2007 00:28:09 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Krzysztof Halasa <khc@pm.waw.pl>, Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Marcel Holtmann <marcel@holtmann.org>,
       Christoph Hellwig <hch@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: MODULE_MAINTAINER
References: <Pine.LNX.4.64.0704230748270.25463@localhost.localdomain> <462CA764.5080401@gmail.com> <20070425181856.42fcfeb4.akpm@linux-foundation.org> <463081E5.5010306@gmail.com> <20070426135426.GM3468@stusta.de> <20070426084143.1d973c71.randy.dunlap@oracle.com> <20070426155205.GN3468@stusta.de> <m38xcfhqp4.fsf@maximus.localdomain> <20070426194316.GY3468@stusta.de> <m3ps5qhpk4.fsf@maximus.localdomain> <20070426202436.GZ3468@stusta.de>
In-Reply-To: <20070426202436.GZ3468@stusta.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2007 10:24 PM, Adrian Bunk wrote:

> The problem with such a database would be the same as with the 
> MAINTAINERS file: The information becomes outdated, and someone has to 
> maintain it.
> 
> Sending a patch against MAINTAINERS is easy - I don't see a 
> WWW-browseable database being in any respect better than the MAINTAINERS
> file.

Well, in fact, the database could _be_ (a parsed version of) the current 
MAINTAINERS file; it's already in a strict, parseable format. I know that 
MAINTAINERS itself is not very good at staying up to date, but making more 
intensive use of it like that might in fact improve that...

Being able to have "modinfo module" then point at a specific link would 
require a bit more though. It could be agreed upon to, say, have a module 
that the kernel installs as

	/lib/modules/$(uname -r)/kernel/drivers/cdrom/mitsumi.ko

have a maintainer page at

	http://www.kernel.org/maintainer/driver/cdrom/mitsumi.html

but to generate that page, the maintainer file would then need to grow a way 
to associate the "MITSUMI CDROM DRIVER" entry (don't bother, it's not there) 
in the MAINTAINERS file with that page (and simply listing that install path 
in the entry isn't good -- I believe you would wan't to pin down a structure 
like that).

Anyways -- might all also be a bit of overkill anyway. If I can get those 
email adresses from MODULE_AUTHOR out of the way, I'm mostly happy.

Rene.

