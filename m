Return-Path: <linux-kernel-owner+w=401wt.eu-S938255AbXGUPtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938255AbXGUPtz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 11:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758684AbXGUPtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 11:49:46 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:39285 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756645AbXGUPtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 11:49:45 -0400
Date: Sat, 21 Jul 2007 17:49:44 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Avi Kivity <avi@qumranet.com>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH] Move KVM, paravirt, lguest, VMI and Xen under arch-level
 Virtualization option
In-Reply-To: <1184905342.10380.263.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0707211748320.21737@fbirervta.pbzchgretzou.qr>
References: <1184905342.10380.263.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 20 2007 14:22, Rusty Russell wrote:
>Subject: [PATCH] Move KVM, paravirt, lguest,
>    VMI and Xen under arch-level Virtualization option
>
>Any objections?

Well btw, would it make sense to also rearrange the directory structure along
with it, i.e.

drivers/kvm    => drivers/virt/kvm
drivers/lguest => drivers/virt/lguest
drivers/xen    => drivers/virt/xen

Then the full kconfig (with menuconfig,if,endif) can go to
drivers/virt/Kconfig.


	Jan
-- 
