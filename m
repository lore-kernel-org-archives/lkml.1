Return-Path: <linux-kernel-owner+w=401wt.eu-S1758618AbXIQTbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758618AbXIQTbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 15:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756363AbXIQTbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 15:31:15 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:51369 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756112AbXIQTbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 15:31:14 -0400
Subject: Re: [PATCH 2/3] Consolidate host virtualization support
	under	Virtualization menu
From: Zachary Amsden <zach@vmware.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Alexey Eremenko <al4321@gmail.com>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
In-Reply-To: <46ED440E.3020209@goop.org>
References: <1189747054.7262.34.camel@localhost.localdomain>
	 <1189747124.7262.36.camel@localhost.localdomain>
	 <20070914091921.73007c5a.randy.dunlap@oracle.com>
	 <1189825504.7262.75.camel@localhost.localdomain>
	 <7fac565a0709150149kf55de62q92496cf74e7b0581@mail.gmail.com>
	 <1189928617.7262.98.camel@localhost.localdomain>
	 <46ED440E.3020209@goop.org>
Content-Type: text/plain
Date: Mon, 17 Sep 2007 12:31:20 -0700
Message-Id: <1190057480.5982.157.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-09-16 at 07:56 -0700, Jeremy Fitzhardinge wrote:
> Rusty Russell wrote:
> > Well, containerization deserves its own menu, but the question is does i
> > it belong under this menu?
> 
> No, I don't think so.  While there are some broad similarities in
> effect, the technology is completely different, as are the capabilities
> and tradeoffs.  They're pretty much orthogonal.

It seems to me containerization is much more similar a feature to SYSV
IPC, process accounting / auditing, and should be an option under
General setup, possibly with its own submenu.  Nearly all the features
under general setup provide optional extensions to kernel services
available from userspace, and so it seems containerization falls
naturally into that category.

Virtualization is completely different, and probably needs separate
server (kvm, lguest) and client (kvm, lguest, xen, vmware) sections in
it's menu.

Zach

