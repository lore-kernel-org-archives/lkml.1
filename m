Return-Path: <linux-kernel-owner+w=401wt.eu-S1757199AbYGOIjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199AbYGOIjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 04:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754765AbYGOIjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 04:39:24 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:3807 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256AbYGOIjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 04:39:23 -0400
Date: Tue, 15 Jul 2008 10:39:01 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Max Krasnyansky <maxk@qualcomm.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       Zachary Amsden <zach@vmware.com>
Subject: Re: [PATCH] stopmachine: add stopmachine_timeout
Message-ID: <20080715083901.GA25335@osiris.boeblingen.de.ibm.com>
References: <487B05CE.1050508@jp.fujitsu.com> <20080714212026.GA6705@osiris.boeblingen.de.ibm.com> <487C0A76.8060401@qualcomm.com> <200807151810.00365.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807151810.00365.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 06:09:59PM +1000, Rusty Russell wrote:
> On Tuesday 15 July 2008 12:24:54 Max Krasnyansky wrote:
> > Heiko Carstens wrote:
> > > On Mon, Jul 14, 2008 at 11:56:18AM -0700, Jeremy Fitzhardinge wrote:
> > > This is asking for trouble... a config option to disable this would be
> > > nice. But as I don't know which problem this patch originally addresses
> > > it might be that this is needed anyway. So lets see why we need it first.
> >
> > How about this. We'll make this a sysctl, as Rusty already did, and set the
> > default to 0 which means "never timeout". That way crazy people like me who
> > care about this scenario can enable this feature.
> 
> Indeed, this was my thought too.  s390 can initialize it to zero somewhere in 
> their boot code.

Shouldn't we default to zero and let whowever wants something different
configure that via sysctl.conf?
Whatever default value > 0 you pick is likely wrong for whatever specific
usecase.
