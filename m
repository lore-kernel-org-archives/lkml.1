Return-Path: <linux-kernel-owner+w=401wt.eu-S1760472AbZC3UM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760472AbZC3UM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 16:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755930AbZC3UMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 16:12:48 -0400
Received: from cantor.suse.de ([195.135.220.2]:59790 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754455AbZC3UMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 16:12:47 -0400
Date: Mon, 30 Mar 2009 22:12:42 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Anders Kaseorg <andersk@mit.edu>,
       Arjan van de Ven <arjan@linux.intel.com>, Tim Abbott <tabbott@mit.edu>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PULL] module and parameter patches
In-Reply-To: <200903302203.31097.rusty@rustcorp.com.au>
Message-ID: <alpine.LRH.2.00.0903302204100.8561@twin.jikos.cz>
References: <200903302203.31097.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Mar 2009, Rusty Russell wrote:

> The following changes since commit 0d34fb8e93ceba7b6dad0062dbb4a0813bacd75b:                      
>   Linus Torvalds (1):                                                                             
>         Merge branch 'bzip2-lzma-for-linus' of git://git.kernel.org/.../x86/linux-2.6-tip         
> 
> are available in the git repository at:
> 
>   ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-module-and-param.git master
> 
> Arjan van de Ven (3):
>       module: create a request_module_nowait()
>       use the new request_module_nowait() in the hid driver
[ ... ]
> commit 743b7e3627cbcd5b04b2d1878b1c6b39e357173e
> Author: Arjan van de Ven <arjan@linux.intel.com>
> Date:   Sun Feb 8 10:42:40 2009 -0800
> 
>     use the new request_module_nowait() in the hid driver
>     
>     Now that there is a request_module_nowait(), use it in the hid driver.
>     This gets rid of a kernel thread, and also greatly simplifies the code...
>     
>     Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
>     Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
>  drivers/hid/hid-core.c |   19 +------------------
>  1 files changed, 1 insertions(+), 18 deletions(-)

Having noticed that Linus hasn't pulled this yet ... Rusty, you can safely 
drop this one. I am currently preparing pull request for HID, which will 
remove the whole hid-dummy stuff altogether, so all this will be removed 
anyway (this is what Stephen has his extra patch in linux-next).

So if you drop this before Linus pulls, it will save us one conflict.

Thanks,

-- 
Jiri Kosina
SUSE Labs

