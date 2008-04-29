Return-Path: <linux-kernel-owner+w=401wt.eu-S1764594AbYD2O7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764594AbYD2O7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 10:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbYD2O7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 10:59:40 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:40701 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbYD2O7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 10:59:39 -0400
Message-ID: <48173607.6080307@freescale.com>
Date: Tue, 29 Apr 2008 09:51:51 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: cross-compiling on OS X, make menuconfig fails
References: <481529B6.6030802@freescale.com> <8FEAC32C-868F-468C-B383-8450D400691C@e18.physik.tu-muenchen.de>
In-Reply-To: <8FEAC32C-868F-468C-B383-8450D400691C@e18.physik.tu-muenchen.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Kuhn wrote:

> For some strange reason Apple decided to change 'echo':
> 
> /bin/bash -c 'echo -e ...' does the right thing
> /bin/sh -c 'echo -e ...' keeps the "-e" in the output but interprets  
> the \n
> /bin/echo -e ... does no interpretation and even keeps the \n

Wow, that is messed up.  Especially since "/bin/sh --version" and "/bin/bash
--version" give me the same output.

Would you say that OS X is broken?  I'm having a hard time finding documentation
for 'sh', so I can't find out what echo -e  is supposed to do in 'sh'.

I read in the latest Linux Journal magazine that someone noticed that even
though the kernel scripts say #!/bin/sh, many of them are really bash scripts.
This person went through the effort of changing the script to be true 'sh'
scripts.  Has that code been merged in?

> I'd recommend installing the coreutils-default package from fink, then  
> you get a sane /sw/bin/echo.

But the scripts still reference /bin/sh, so I would need to change the scripts
or symlink /bin/sh.  If I'm going to symlink /bin/sh, I'd rather just symlink it
to /bin/bash.

> Side-note on sanity: ISTR that POSIX defines echo in this (/bin/echo)  
> strange way, urging people to use printf instead.

But printf is bash, not sh.  I would need to change #!/bin/sh to #!/bin/bash.

-- 
Timur Tabi
Linux kernel developer at Freescale
