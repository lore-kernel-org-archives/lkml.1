Return-Path: <linux-kernel-owner+w=401wt.eu-S1755474AbZLWMOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbZLWMOi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 07:14:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754969AbZLWMOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 07:14:36 -0500
Received: from one.firstfloor.org ([213.235.205.2]:56478 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493AbZLWMOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 07:14:36 -0500
Date: Wed, 23 Dec 2009 13:14:32 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Avi Kivity <avi@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Gregory Haskins <gregory.haskins@gmail.com>, kvm@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>
Subject: Re: [GIT PULL] AlacrityVM guest drivers for 2.6.33
Message-ID: <20091223121431.GF20539@basil.fritz.box>
References: <4B1D4F29.8020309@gmail.com> <87637zdy9g.fsf@basil.nowhere.org> <4B30E654.40702@codemonkey.ws> <200912221701.56840.bzolnier@gmail.com> <4B30F214.80206@codemonkey.ws> <20091223065129.GA19600@elte.hu> <20091223101340.GC20539@basil.fritz.box> <4B31EF65.6070000@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B31EF65.6070000@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> http://www.redhat.com/f/pdf/summit/cwright_11_open_source_virt.pdf
>
> See slide 32.  This is without vhost-net.

Thanks. Do you also have latency numbers?

It seems like there's definitely still potential for improvement
with messages <4K. But for the large messages they indeed 
look rather good.

It's unclear what message size the Alacrity numbers used, but I presume
it was rather large.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
