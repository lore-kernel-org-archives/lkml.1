Return-Path: <linux-kernel-owner+w=401wt.eu-S1752317AbZALIDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbZALIDy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 03:03:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754765AbZALIDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 03:03:41 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39919 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177AbZALIDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 03:03:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
Subject: Re: 2.6.29-rc1 does not resume on Lenove T61
Date: Mon, 12 Jan 2009 09:03:19 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: "Maciej Rutecki" <maciej.rutecki@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
References: <c4e36d110901111152o63c4cda0j88f4c89950bd2b90@mail.gmail.com> <8db1092f0901111215m5712caccvc0d2e5e7cb7e8f7@mail.gmail.com> <c4e36d110901111459p6d02892fwce0d89c52e62385e@mail.gmail.com>
In-Reply-To: <c4e36d110901111459p6d02892fwce0d89c52e62385e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901120903.20371.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 January 2009, Zdenek Kabelac wrote:
> 2009/1/11 Maciej Rutecki <maciej.rutecki@gmail.com>:
> > 2009/1/11 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
> >> Hi
> >>
> >> I've booted and tested 2.6.29-rc1 (c59765042f53a79a7a65585042ff463b69cb248c)
> >>
> >> I've observed that suspend is unusable - it goes to sleep - the sleep
> >> LED is on. After few secs system turns on back itself - and stays in
> >> some frozen state
> >
> > A have similar situation, one difference: I get blank screen during
> > resume from suspend to ram. Also sometimes, like You, system turns on
> > back itself.
> >
> 
> So it looks like reverting this commit:
> 
> http://marc.info/?l=linux-kernel&m=123140019117968&w=4
> (6fd9086a518d4f14213a32fe6c9ac17fabebbc1e)
> (which is already a tracked regression)
> fixes the problem with auto-resume
> 
> But the problem with deadlock in the resume phase is still there.

Please check if unloading all of the USB controller modules before suspend
helps.

Thanks,
Rafael
