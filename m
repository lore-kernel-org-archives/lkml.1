Return-Path: <linux-kernel-owner+w=401wt.eu-S965977AbXDBWEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965977AbXDBWEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 18:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965986AbXDBWEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 18:04:34 -0400
Received: from gw.goop.org ([64.81.55.164]:54861 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965977AbXDBWEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 18:04:33 -0400
Message-ID: <46117DE9.6060506@goop.org>
Date: Mon, 02 Apr 2007 15:04:25 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Anthony Liguori <aliguori@us.ibm.com>
CC: Andi Kleen <ak@suse.de>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Jeff Garzik <jeff@garzik.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mathiasen@gmail.com, virtualization@lists.linux-foundation.org
Subject: Re: A set of "standard" virtual devices?
References: <4611652F.700@zytor.com> <200704022312.39195.ak@suse.de>	<4611768D.1080801@garzik.org> <200704022336.43136.ak@suse.de> <461178D9.402@goop.org> <46117B62.9030902@us.ibm.com>
In-Reply-To: <46117B62.9030902@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
> The actual PCI bus could paravirtualized.  It's just a question of
> whether one reinvents a device discovery mechanism (like XenBus) or
> whether one piggy backs on existing mechanisms.
>
> Furthermore, in the future, I strongly suspect that HVM will become
> much more important for Xen than PV and since that already has a PCI
> bus it's not really that big of a deal. 

Well, obviously it keeps things simple for me to not worry about PCI
support in Xen at this point.  But I was thinking more of lguest; I
think PCI emulation would kill puppies.

    J
