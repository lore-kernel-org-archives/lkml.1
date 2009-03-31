Return-Path: <linux-kernel-owner+w=401wt.eu-S1761639AbZCaC3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761639AbZCaC3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 22:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755051AbZCaC3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 22:29:36 -0400
Received: from ozlabs.org ([203.10.76.45]:39502 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753202AbZCaC3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 22:29:36 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PULL] module and parameter patches
Date: Tue, 31 Mar 2009 12:59:26 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       =?iso-8859-1?q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Anders Kaseorg <andersk@mit.edu>,
       Arjan van de Ven <arjan@linux.intel.com>, Tim Abbott <tabbott@mit.edu>,
       Russell King <rmk@arm.linux.org.uk>
References: <200903302203.31097.rusty@rustcorp.com.au> <alpine.LRH.2.00.0903302204100.8561@twin.jikos.cz>
In-Reply-To: <alpine.LRH.2.00.0903302204100.8561@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903311259.27645.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 March 2009 06:42:42 Jiri Kosina wrote:
> On Mon, 30 Mar 2009, Rusty Russell wrote:
> 
> > The following changes since commit 0d34fb8e93ceba7b6dad0062dbb4a0813bacd75b:                      
> >   Linus Torvalds (1):                                                                             
> >         Merge branch 'bzip2-lzma-for-linus' of git://git.kernel.org/.../x86/linux-2.6-tip         
> > 
> > are available in the git repository at:
> > 
> >   ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-module-and-param.git master
> > 
> > Arjan van de Ven (3):
> >       module: create a request_module_nowait()
> >       use the new request_module_nowait() in the hid driver
> [ ... ]
> > commit 743b7e3627cbcd5b04b2d1878b1c6b39e357173e
> > Author: Arjan van de Ven <arjan@linux.intel.com>
> > Date:   Sun Feb 8 10:42:40 2009 -0800
> > 
> >     use the new request_module_nowait() in the hid driver
> >     
> >     Now that there is a request_module_nowait(), use it in the hid driver.
> >     This gets rid of a kernel thread, and also greatly simplifies the code...
> >     
> >     Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> >     Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> > 
> >  drivers/hid/hid-core.c |   19 +------------------
> >  1 files changed, 1 insertions(+), 18 deletions(-)
> 
> Having noticed that Linus hasn't pulled this yet ... Rusty, you can safely 
> drop this one. I am currently preparing pull request for HID, which will 
> remove the whole hid-dummy stuff altogether, so all this will be removed 
> anyway (this is what Stephen has his extra patch in linux-next).
> 
> So if you drop this before Linus pulls, it will save us one conflict.

Sure!  The other use-request_module_nowait patch also has clashes, so I
dropped that too.

Should be easy for Arjan to respin and re-send once request_module_nowait is
in.

Thanks!
Rusty.
