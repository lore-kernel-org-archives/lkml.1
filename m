Return-Path: <linux-kernel-owner+w=401wt.eu-S1754498AbXEFCmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbXEFCmA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 22:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754689AbXEFCmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 22:42:00 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:64214 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498AbXEFCl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 22:41:59 -0400
Date: Sat, 05 May 2007 20:41:52 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: "modularized" 2.4.34.4  ->  ide-core "unresolved symbols"
In-reply-to: <fa.rg7bSh1mNv1yib9QUzNuRvWTPe8@ifi.uio.no>
To: Zbigniew Baniewski <zb@ispid.com.pl>
Cc: linux-kernel@vger.kernel.org
Message-id: <463D4070.4080802@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-2; format=flowed
Content-transfer-encoding: 7bit
References: <fa.rg7bSh1mNv1yib9QUzNuRvWTPe8@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zbigniew Baniewski wrote:
> Hallo,
> 
> I was trying to make "modularized kernel" (s.c. "Debian way") recently, yes,
> I made even kernel.deb package - but at the installation, I'm still getting
> an error: "ide-core: unresolved symbols".
> 
> Making a quick search with Google I could see, it did occur to many other
> people even long ago. There was even a patch introduced - which, I believe,
> is in the 2.4.34.4 "drivers/ide" sub-dir - unfortunately it seems, that the
> patch is working no more.
> 
> Perhaps there is another patch available for 2.4.34.4 ?

I don't think drivers/ide ever really played well when built modular, at 
least not in 2.4, quite possibly in 2.6 as well. Things like DMA not 
getting turned on automatically when the low-level driver was a module, 
etc. Likely why Red Hat/Fedora never built it modular when they did 
everything else..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

