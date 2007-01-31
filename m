Return-Path: <linux-kernel-owner+w=401wt.eu-S932736AbXAaJZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736AbXAaJZT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 04:25:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932749AbXAaJZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 04:25:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33554 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932736AbXAaJZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 04:25:17 -0500
From: Andi Kleen <ak@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] suspend debugging: simulate suspend-to-RAM
Date: Wed, 31 Jan 2007 10:25:04 +0100
User-Agent: KMail/1.9.5
Cc: Andrey Borzenkov <arvidjaar@mail.ru>, linux-kernel@vger.kernel.org,
       bk@suse.de
References: <20070125113350.GA31068@elte.hu> <p73ejpd96x9.fsf@bingen.suse.de> <20070131091235.GA20306@elte.hu>
In-Reply-To: <20070131091235.GA20306@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701311025.04244.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 January 2007 10:12, Ingo Molnar wrote:
> 
> * Andi Kleen <ak@suse.de> wrote:
> 
> > Andrey Borzenkov <arvidjaar@mail.ru> writes:
> > 
> > > Will it work with netconsole too? COM port is often missing in notebooks
> > > today.
> > 
> > It will work with some luck with firescope (in the worst case you
> > might need to disable suspend in ochi1394). Many laptops have firewire
> > ports.
> > 
> > ftp://ftp.firstfloor.org/pub/ak/firescope/
> 
> wow, that's really neat!

To give proper credit firescope originally came from Ben Herrenschmidt
for PPC. I just ported it to x86 with a few changes.

BTW if you like firescope you might also like fireproxy
http://www.suse.de/~bk/firewire/

There's also a early ohci1394 driver in there to make
firescope/fireproxy work earlier during boot, but it's still somewhat
experimental.

-Andi
