Return-Path: <linux-kernel-owner+w=401wt.eu-S1754199AbZLOGUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbZLOGUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 01:20:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753868AbZLOGUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 01:20:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57360 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753669AbZLOGUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 01:20:30 -0500
Date: Mon, 14 Dec 2009 22:20:23 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Russ Dill <russ.dill@gmail.com>
cc: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
Subject: Re: [GIT PATCH] USB patches for 2.6.33-git
In-Reply-To: <4B2728AC.8050001@gmail.com>
Message-ID: <alpine.LFD.2.00.0912142220040.14385@localhost.localdomain>
References: <g383sjib9r8nlmw354UYAxe124vaj_firegpg@mail.gmail.com>  <1260849652.28808.1.camel@russ-laptop>  <alpine.LFD.2.00.0912142031170.14385@localhost.localdomain> <1260852335.1886.0.camel@russ-laptop> <alpine.LFD.2.00.0912142158260.14385@localhost.localdomain>
 <4B2728AC.8050001@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Dec 2009, Russ Dill wrote:
> 
> I'll test tomorrow be sure, but It seems fine. really_probe in
> drivers/base/dd.c is setting dev->driver before calling drv->probe.
> driver_bound is called after drv->prove which adds the device to the
> driver klist_devices.

Ok, sounds good. Just checking.

		Linus
