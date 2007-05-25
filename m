Return-Path: <linux-kernel-owner+w=401wt.eu-S1753837AbXEYWte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbXEYWte (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 18:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbXEYWt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 18:49:27 -0400
Received: from gate.crashing.org ([63.228.1.57]:58067 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628AbXEYWt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 18:49:26 -0400
Subject: Re: [patch 5/7] ps3: Disk Storage Driver
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linuxppc-dev@ozlabs.org, Geert.Uytterhoeven@sonycom.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <200705251826.25572.arnd@arndb.de>
References: <20070525083607.784351000@sonycom.com>
	 <20070525083632.575306000@sonycom.com>  <200705251826.25572.arnd@arndb.de>
Content-Type: text/plain
Date: Sat, 26 May 2007 08:48:55 +1000
Message-Id: <1180133335.19517.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> So the hypervison uses guest-real addresses here? I would have expected
> it to use the kernel page tables, which lets you use vmap() to do
> scatter-gather.

Ugh ? Maybe s390 can do that but no other hypervisor that I know
about :-) It would be nice, sure, but heh.

> I don't really understand what the kthread is needed for. You probably
> thought about multiple options and ended up with this, but having
> a comment in front of it might be helpful.

Yeah, me neither... the driver looks very very very unefficient to me. I
though the kthread was useful for hotplug detection becasue the
hypervisor don't signal us, but from the patch, it looks like it's also
used for actual request processing which is very yucky.

Ben.



