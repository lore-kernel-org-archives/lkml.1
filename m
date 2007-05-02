Return-Path: <linux-kernel-owner+w=401wt.eu-S1754142AbXEBHDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbXEBHDF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 03:03:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754886AbXEBHDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 03:03:05 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:60806 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142AbXEBHDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 03:03:03 -0400
X-Originating-Ip: 74.109.98.66
Date: Wed, 2 May 2007 03:02:41 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 01/10] compiler: define __attribute_unused__
In-Reply-To: <20070502051723.GB5843@martell.zuzino.mipt.ru>
Message-ID: <Pine.LNX.4.64.0705020257520.5859@localhost.localdomain>
References: <Pine.LNX.4.64.0705012118130.19277@chino.kir.corp.google.com>
 <20070502051723.GB5843@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007, Alexey Dobriyan wrote:

> On Tue, May 01, 2007 at 09:28:18PM -0700, David Rientjes wrote:
> > +#define __attribute_unused__		__attribute__((unused))
>
> Suggest __unused which is shorter and looks compiler-neutral.

  not only that, but there are numerous files that *already* use
"__unused":

$ grep -rw __unused *
... snip lots of output here ...

as well as a few files that can now have their definition of that
removed:

$ grep -r "define __unused" *
drivers/net/defxx.c:#define __unused __attribute__ ((unused))
drivers/net/declance.c:#define __unused __attribute__ ((unused))
drivers/misc/thinkpad_acpi.c:#define __unused __attribute__ ((unused))

  i think "__unused" is the clear choice here.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
