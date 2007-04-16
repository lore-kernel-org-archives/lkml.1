Return-Path: <linux-kernel-owner+w=401wt.eu-S1754326AbXDPCxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbXDPCxl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 22:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754334AbXDPCxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 22:53:41 -0400
Received: from outmail1.freedom2surf.net ([194.106.33.237]:53368 "EHLO
	outmail1.freedom2surf.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326AbXDPCxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 22:53:41 -0400
X-Greylist: delayed 1220 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Apr 2007 22:53:40 EDT
Subject: Re: [Kernel-discuss] Re: [PATCH 3/7] [RFC] Battery monitoring class
From: ian <spyro@f2s.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Anton Vorontsov <cbou@mail.ru>, Ondrej Zajicek <santiago@crfreenet.org>,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       kernel-discuss@handhelds.org
In-Reply-To: <20070416005722.GA6296@khazad-dum.debian.net>
References: <20070411232503.GC20095@zarina>
	 <20070415220854.GA20373@localhost.localdomain>
	 <20070415225049.GA27680@zarina>
	 <20070416005722.GA6296@khazad-dum.debian.net>
Content-Type: text/plain
Date: Mon, 16 Apr 2007 03:32:54 +0100
Message-Id: <1176690774.29389.175.camel@wirenth>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-15 at 21:57 -0300, Henrique de Moraes Holschuh wrote:
> 
> No, that won't help much.  IMO, we want the sanest set of standard
> attributes we can get, and weird as it might be, average reporting are
> common properties of battery control firmware on laptops (maybe
> because of SBS, but still...).

We need to think very carefully here.

charge, current, capacity, etc. are properties all batteries have, and
the current values can all be sampled instantaneously.

funky values processed by 'black box' firmware are not universal
properties of all batteries.

IOW, battery class should be for 'simple' battery types only.

perhaps rename it to simple battery class to make it distinct?

Userspace is the place to put the complications, in any case, and I see
nothing wrong with having both a simple battery class AND other
proprietary battery class an SBS battery class. (or a
toshiba_proprietary_bios battery class or whatever).

Perhaps we need a 'libbattery.so' so that userspace can have a nice
consistent interface?

