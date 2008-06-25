Return-Path: <linux-kernel-owner+w=401wt.eu-S1758266AbYFYTCH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266AbYFYTCH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 15:02:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbYFYTB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 15:01:56 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43605 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbYFYTBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 15:01:55 -0400
Date: Wed, 25 Jun 2008 21:13:15 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Keir Fraser <keir.fraser@eu.citrix.com>
Cc: Andi Kleen <andi@firstfloor.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Mark McLoughlin <markmc@redhat.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       Eduardo Habkost <ehabkost@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Stephen Tweedie <sct@redhat.com>
Subject: Re: [Xen-devel] Re: [PATCH 00 of 36] x86/paravirt: groundwork for 64-bit Xen support
Message-ID: <20080625191315.GD6708@one.firstfloor.org>
References: <87skv1r8ln.fsf@basil.nowhere.org> <C48850E0.231A8%keir.fraser@eu.citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C48850E0.231A8%keir.fraser@eu.citrix.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What does Linux expect to scale up to? Reserving 16 PML4 entries leaves the
> kernel with 120TB of available 'negative' address space. Should be plenty, I
> would think.

There are already (ok non x86-64) systems shipping today with 10+TB of 
addressable memory. 100+TB is not that far away with typical
growth rates. Besides there has to be much more in the negative address
space than just direct mapping.

So far we always that 64bit Linux can support upto 1/4*max VA memory.
With your change that formula would be not true anymore.

-Andi 


