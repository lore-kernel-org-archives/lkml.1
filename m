Return-Path: <linux-kernel-owner+w=401wt.eu-S1757342AbZDJINt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342AbZDJINt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 04:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759325AbZDJINP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 04:13:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58399 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758646AbZDJINM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 04:13:12 -0400
Date: Fri, 10 Apr 2009 10:15:15 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
To: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>
Cc: Justin Madru <jdm64@gawab.com>, lkml <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.30-rc1: invalid opcode with call trace
Message-ID: <20090410081515.GA17762@fancy-poultry.org>
Reply-To: linux-kernel@vger.kernel.org
References: <49DC367A.90603@gawab.com> <20090408063240.GQ5178@kernel.dk> <20090408064733.GA16984@elte.hu> <20090408065201.GA6490@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090408065201.GA6490@elte.hu>
Organization: private site
User-Agent: Mutt/1.5.19+20090405 (GNU/Linux)
X-Provags-ID: V01U2FsdGVkX1+zGk1mTBmagdyrmquHEsuTfiWZTVwL++t5UuI
 aVIxfhR77FpCyrXhoDjTju+nDfNz0s6XINvAswrif5QWu1rk6v
 MwZe7g6L9Pmt+oDaqeX8lRqzpSPvMto
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.04.2009, Ingo Molnar wrote: 

One additional bug which is caused by commit 9710794:

> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > I too have an async hang/crash, on an old-style SCSI (aic7xxx) box 
> > - hang log attached below.
> > [...]
> >
> > ( Full bootlog attached below as well - i'm sending the config as a 
> >   reply as this mail is close to lkml size limits already. )
> 
> Config attached.
> 
>  known bad  : v2.6.29-9854-gd508afb
>  known good : v2.6.29
> 
> Suspected commit introducing the regression:
> 
>  9710794: async: remove the temporary (2.6.29) "async is off by default" code
> 
> (i'll now try a revert of this.)
> 
> 	Ingo

When trying to boot 2.6.30-rc1, -git3 on my notebook, which
has an encrypted root partition (LUKS/dmcrypt), the root fs can
not be found any more. 

The bootscreen finally shows:
[....]
Could not find /dev/mapper/root
...exiting to /bin/sh

And the system is dead. Since there's no root fs available, I can't provide
any more information on this.

BUT: Ingo's reversion does fix this.

Regards, 
Heinz.

