Return-Path: <linux-kernel-owner+w=401wt.eu-S934125AbXHLKwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934125AbXHLKwZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 06:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759990AbXHLKwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 06:52:18 -0400
Received: from ns2.suse.de ([195.135.220.15]:52009 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759353AbXHLKwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 06:52:18 -0400
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: Are we properly prepared to handle 3 Socket setups?
References: <9a8748490708111808o11d354fr9efa719bc38046c5@mail.gmail.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 12 Aug 2007 13:46:30 +0200
In-Reply-To: <9a8748490708111808o11d354fr9efa719bc38046c5@mail.gmail.com>
Message-ID: <p73absxj7qh.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Jesper Juhl" <jesper.juhl@gmail.com> writes:

> I just saw a news article (http://www.theinquirer.net/?article=41610)
> about a 3 Socket Opteron motherboard and couldn't help but wonder if
> we are prepared to deal with such a beast, so I thought I'd inform
> everyone :-)

It should work. Non power of two cores per socket used to be problematic
though, but that has been also fixed.

> nr_of_cpus being an even number... In any case it would be an
> interresting box to test on, so for those of you employed by big
> business with the cash to purchase a test box, it would at least be an
> interresting one to add to the mix :)

You can already test it by either using qemu/xen/etc. or by 
off lining one of your cores if you have more than 2.

-Andi
