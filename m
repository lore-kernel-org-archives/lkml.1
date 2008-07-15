Return-Path: <linux-kernel-owner+w=401wt.eu-S1757004AbYGOGKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004AbYGOGKc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 02:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754049AbYGOGKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 02:10:23 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:2537 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940AbYGOGKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 02:10:23 -0400
Date: Tue, 15 Jul 2008 08:09:24 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       Zachary Amsden <zach@vmware.com>
Subject: Re: [PATCH] stopmachine: add stopmachine_timeout
Message-ID: <20080715060923.GA4669@osiris.boeblingen.de.ibm.com>
References: <487B05CE.1050508@jp.fujitsu.com> <200807141351.25092.borntraeger@de.ibm.com> <200807142234.40700.rusty@rustcorp.com.au> <487BA152.1070102@goop.org> <20080714212026.GA6705@osiris.boeblingen.de.ibm.com> <487C0A76.8060401@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487C0A76.8060401@qualcomm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> So I think monotonic wallclock time actually makes the most sense here.
> > 
> > This is asking for trouble... a config option to disable this would be
> > nice. But as I don't know which problem this patch originally addresses
> > it might be that this is needed anyway. So lets see why we need it first.
> How about this. We'll make this a sysctl, as Rusty already did, and set the
> default to 0 which means "never timeout". That way crazy people like me who
> care about this scenario can enable this feature.

Yes, sounds like that should work for everyone and no additional config
option as well. Sounds good to me.
