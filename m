Return-Path: <linux-kernel-owner+w=401wt.eu-S1755285AbYFJNy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbYFJNy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 09:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753781AbYFJNys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 09:54:48 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:53871 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753745AbYFJNyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 09:54:47 -0400
Date: Tue, 10 Jun 2008 16:53:49 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Bryan Wu <cooloney@kernel.org>, Jeff Garzik <jeff@garzik.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: blackfin drivers/net/smc91x.c build error
Message-ID: <20080610135349.GA30792@cs181133002.pp.htv.fi>
References: <20080606162212.GC2201@cs181133002.pp.htv.fi> <8bd0f97a0806061252n1cf5ee33i40ddf9f55588e242@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8bd0f97a0806061252n1cf5ee33i40ddf9f55588e242@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2008 at 03:52:09PM -0400, Mike Frysinger wrote:
> On Fri, Jun 6, 2008 at 12:22 PM, Adrian Bunk <bunk@kernel.org> wrote:
> > drivers/net/smc91x.c fails as follows on blackfin:
> > ...
> >  CC      drivers/net/smc91x.o
> > ...
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/net/smc91x.c:1863:36: error: macro "SMC_GET_MAC_ADDR" passed 2 arguments, but takes just 1
> > ...
> 
> it's a known issue (been known for quite a long time actually).  Bryan
> has brought this up in the past already.

Is my suggestion of reverting commit 099c736a470c8080a166e7a089f1e48e15f9947c
correct or how else should it be resolved?

This issue is the only remaining problem preventing that all blackfin 
defconfigs will compile in 2.6.26...

> -mike

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

