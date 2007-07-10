Return-Path: <linux-kernel-owner+w=401wt.eu-S1762843AbXGJIof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762843AbXGJIof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 04:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756268AbXGJIo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 04:44:28 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:34014 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756121AbXGJIo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 04:44:28 -0400
To: balbir@linux.vnet.ibm.com
Cc: svaidy@linux.vnet.ibm.com, akpm@linux-foundation.org, xemul@openvz.org,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, ebiederm@xmission.com, containers@lists.osdl.org,
       menage@google.com
Subject: Re: [-mm PATCH 4/8] Memory controller memory accounting (v2)
In-Reply-To: Your message of "Tue, 10 Jul 2007 14:11:18 +0530"
	<661de9470707100141h779e75eev9c09fdb2dfd09b8b@mail.gmail.com>
References: <661de9470707100141h779e75eev9c09fdb2dfd09b8b@mail.gmail.com>
X-Mailer: Cue version 0.8 (070404-1613/takashi)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20070710084427.3F74B1BF77E@siro.lan>
Date: Tue, 10 Jul 2007 17:44:27 +0900 (JST)
From: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On 7/10/07, YAMAMOTO Takashi <yamamoto@valinux.co.jp> wrote:
> > hi,
> >
> > > diff -puN mm/memory.c~mem-control-accounting mm/memory.c
> > > --- linux-2.6.22-rc6/mm/memory.c~mem-control-accounting       2007-07-05 13:45:18.000000000 -0700
> > > +++ linux-2.6.22-rc6-balbir/mm/memory.c       2007-07-05 13:45:18.000000000 -0700
> >
> > > @@ -1731,6 +1736,9 @@ gotten:
> > >               cow_user_page(new_page, old_page, address, vma);
> > >       }
> > >
> > > +     if (mem_container_charge(new_page, mm))
> > > +             goto oom;
> > > +
> > >       /*
> > >        * Re-check the pte - we dropped the lock
> > >        */
> >
> > it seems that the page will be leaked on error.
> 
> You mean meta_page right?

no.  i meant 'new_page'.

YAMAMOTO Takashi
