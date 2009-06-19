Return-Path: <linux-kernel-owner+w=401wt.eu-S1757934AbZFSUb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934AbZFSUb3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 16:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757476AbZFSUbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 16:31:14 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:54436 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757470AbZFSUbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 16:31:13 -0400
Message-ID: <4A3BF591.3060500@msgid.tls.msk.ru>
Date: Sat, 20 Jun 2009 00:31:13 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: ronis@ronispc.chem.mcgill.ca
CC: linux-kernel@vger.kernel.org
Subject: Re: Panic booting 2.6.30
References: <1245439404.25076.7.camel@ronispc.chem.mcgill.ca>	 <4A3BE7EA.4050800@msgid.tls.msk.ru> <1245442742.25076.9.camel@ronispc.chem.mcgill.ca>
In-Reply-To: <1245442742.25076.9.camel@ronispc.chem.mcgill.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Ronis wrote:
> Thanks for the reply.  I added large-memory to lilo.conf, reran lilo,
> and rebooted.  I get the same problem, except now the unknown-block was
> 3,2. when I boot without specifying root=hda2, with root=hda2 I get the
> same behavior.

In that case you'll have to provide much more details.  Boot log probably
using netconsole.  Check config differences.

I suggested large-memory lilo option because your lilo.conf didn't have
it and 2.6.30 is known to outgrow default lilo assumptions.  So it wasn't
your case, it has to be in config change or in something failing during
boot.

Examine boot log (you can try adding vga=ask and choosing the largest
resolution offered, and also try loglevel=4 or loglevel=5 this will
reduce printk noise printed on the console) and config changes.

And please don't top-post.

/mjt
