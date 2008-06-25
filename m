Return-Path: <linux-kernel-owner+w=401wt.eu-S1753517AbYFYUDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbYFYUDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 16:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbYFYUDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 16:03:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43334 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbYFYUDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 16:03:07 -0400
Date: Wed, 25 Jun 2008 22:14:27 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Keir Fraser <keir.fraser@eu.citrix.com>
Cc: Andi Kleen <andi@firstfloor.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Mark McLoughlin <markmc@redhat.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       Eduardo Habkost <ehabkost@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Stephen Tweedie <sct@redhat.com>
Subject: Re: [Xen-devel] Re: [PATCH 00 of 36] x86/paravirt: groundwork for 64-bit Xen support
Message-ID: <20080625201427.GE6708@one.firstfloor.org>
References: <20080625191315.GD6708@one.firstfloor.org> <C48859A2.231C5%keir.fraser@eu.citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C48859A2.231C5%keir.fraser@eu.citrix.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There are obviously no x64 boxes around at the moment with >1TB of regular
> shared memory, since no CPUs have more than 40 address lines. 100+TB RAM is

That's actually not true.

> surely years away.

Yes, but why build something non scalable now that you have to fix in a few
years?  Especially when it comes with "i have no justification" in
the commit log.

> > So far we always that 64bit Linux can support upto 1/4*max VA memory.
> > With your change that formula would be not true anymore.
> 
> Does the formula have any practical significance?

Yes, because getting more than 48bits of VA will be extremly costly
in terms of infrastructure and assuming continuing growth rates and very large
machines 46bits is not all that much.

-Andi
