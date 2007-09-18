Return-Path: <linux-kernel-owner+w=401wt.eu-S1758524AbXIRASf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524AbXIRASf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 20:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753506AbXIRAS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 20:18:26 -0400
Received: from gw.goop.org ([64.81.55.164]:36670 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608AbXIRAS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 20:18:26 -0400
Message-ID: <46EF1952.3010604@goop.org>
Date: Mon, 17 Sep 2007 17:18:26 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Charles N Wyble <charles@thewybles.com>
CC: Zachary Amsden <zach@vmware.com>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 2/3] Consolidate host virtualization support	under	Virtualization
 menu
References: <1189747054.7262.34.camel@localhost.localdomain>	<1189747124.7262.36.camel@localhost.localdomain>	<20070914091921.73007c5a.randy.dunlap@oracle.com>	<1189825504.7262.75.camel@localhost.localdomain>	<7fac565a0709150149kf55de62q92496cf74e7b0581@mail.gmail.com>	<1189928617.7262.98.camel@localhost.localdomain>	<46ED440E.3020209@goop.org> <1190057480.5982.157.camel@bodhitayantram.eng.vmware.com> <46EF0E0A.2000804@thewybles.com>
In-Reply-To: <46EF0E0A.2000804@thewybles.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Charles N Wyble wrote:
>
>
> Zachary Amsden wrote:
> <snip>>
> > Virtualization is completely different, and probably needs separate
> > server (kvm, lguest) and client (kvm, lguest, xen, vmware) sections in
> > it's menu.
>
>
> So what is the differentiation between client and server above? Just
> curious what makes kvm and lguest server and client.

"Host" and "guest" are better terms, I think.  Kvm is all host, since
guests need no modification.  lguest turns the kernel into both host and
guest.  Xen Linux kernels are all guest, since the Xen hypervisor is the
host.

    J
