Return-Path: <linux-kernel-owner+w=401wt.eu-S1762266AbXGFJHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762266AbXGFJHY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 05:07:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755108AbXGFJHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 05:07:13 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:56527 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829AbXGFJHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 05:07:11 -0400
To: benh@kernel.crashing.org
CC: miklos@szeredi.hu, nigel@suspend2.net, rjw@sisk.pl, pavel@ucw.cz,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, oliver@neukum.org, paulus@samba.org, mingo@elte.hu
In-reply-to: <1183712394.3388.128.camel@localhost.localdomain> (message from
	Benjamin Herrenschmidt on Fri, 06 Jul 2007 18:59:54 +1000)
Subject: Re: [RFC][PATCH -mm] PM: Do not sync filesystems from within the
	freezer
References: <200707041658.59588.rjw@sisk.pl>
	 <20070705220046.GC3881@elf.ucw.cz> <200707060902.55090.rjw@sisk.pl>
	 <200707061707.23316.nigel@nigel.suspend2.net>
	 <E1I6i0N-0003CY-00@dorka.pomaz.szeredi.hu> <1183712394.3388.128.camel@localhost.localdomain>
Message-Id: <E1I6jlB-0003TC-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 06 Jul 2007 11:05:53 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 2007-07-06 at 09:13 +0200, Miklos Szeredi wrote:
> > 
> > Another myth, that has been debunked already.  The problem is: how do
> > you define fuse processes?  There's no theoretical or even practial
> > way to do that.
> 
> It could if they told the kernel via some black magic ...
> 
> But that still suck. The freezer sucks :-)

Yeah, and it wouldn't work in practice, since the auxilary tasks might
be part of a library which is not even aware of being used by a "fuse
task".

Miklos
