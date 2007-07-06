Return-Path: <linux-kernel-owner+w=401wt.eu-S1761637AbXGFJAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761637AbXGFJAy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 05:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755108AbXGFJAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 05:00:47 -0400
Received: from gate.crashing.org ([63.228.1.57]:47819 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834AbXGFJAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 05:00:46 -0400
Subject: Re: [RFC][PATCH -mm] PM: Do not sync filesystems from within the
	freezer
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: nigel@suspend2.net, rjw@sisk.pl, pavel@ucw.cz,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, oliver@neukum.org, paulus@samba.org, mingo@elte.hu
In-Reply-To: <E1I6i0N-0003CY-00@dorka.pomaz.szeredi.hu>
References: <200707041658.59588.rjw@sisk.pl>
	 <20070705220046.GC3881@elf.ucw.cz> <200707060902.55090.rjw@sisk.pl>
	 <200707061707.23316.nigel@nigel.suspend2.net>
	 <E1I6i0N-0003CY-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain
Date: Fri, 06 Jul 2007 18:59:54 +1000
Message-Id: <1183712394.3388.128.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-06 at 09:13 +0200, Miklos Szeredi wrote:
> 
> Another myth, that has been debunked already.  The problem is: how do
> you define fuse processes?  There's no theoretical or even practial
> way to do that.

It could if they told the kernel via some black magic ...

But that still suck. The freezer sucks :-)

Ben.


