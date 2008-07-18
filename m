Return-Path: <linux-kernel-owner+w=401wt.eu-S1752869AbYGRESU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbYGRESU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 00:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750859AbYGRESN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 00:18:13 -0400
Received: from ozlabs.org ([203.10.76.45]:55986 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbYGRESM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 00:18:12 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH] stopmachine: add stopmachine_timeout v2
Date: Fri, 18 Jul 2008 14:18:09 +1000
User-Agent: KMail/1.9.9
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       virtualization@lists.linux-foundation.org,
       Zachary Amsden <zach@vmware.com>, Max Krasnyansky <maxk@qualcomm.com>
References: <487B05CE.1050508@jp.fujitsu.com> <487DC943.5060202@goop.org> <487EBF1E.5030109@jp.fujitsu.com>
In-Reply-To: <487EBF1E.5030109@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807181418.09883.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 July 2008 13:40:14 Hidetoshi Seto wrote:
> Jeremy Fitzhardinge wrote:
> > Hidetoshi Seto wrote:
> >> +#ifdef CONFIG_STOP_MACHINE
> >> +extern unsigned long stopmachine_timeout;
> >> +#endif
> >
> > No externs in C files. Put it in an appropriate header.
>
> sysctl.c already has many externs... but I can fix at least
> the above.

I already patched this; checkpatch.pl warned about it :)

> > I'll do a proper review soon.
>
> Is it better to postpone v4 until your comment comes?

I think the only other real change is to make the value in ms, not seconds,
and allow a 0 value to mean "don't check".

Cheers,
Rusty.

