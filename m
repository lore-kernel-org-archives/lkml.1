Return-Path: <linux-kernel-owner+w=401wt.eu-S1755331AbYGaJxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbYGaJxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 05:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbYGaJxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 05:53:10 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:48162 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbYGaJxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 05:53:09 -0400
Subject: Re: [BUG] wireless : cpu stuck for 61s
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Dave Young <hidave.darkstar@gmail.com>,
       Johannes Berg <johannes@sipsolutions.net>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240807310250kd2df7bfxa3591cf78e68f8dc@mail.gmail.com>
References: <20080729055731.GA3265@darkstar>
	 <1217334724.10489.47.camel@johannes.berg>
	 <20080730020820.8bcc00e2.akpm@linux-foundation.org>
	 <a8e1da0807300302m35a0a7c0q2ff2e0ab92a69239@mail.gmail.com>
	 <20080730031047.54e13e2d.akpm@linux-foundation.org>
	 <a8e1da0807301906j6438e5d8y64105fe8a2e3dffe@mail.gmail.com>
	 <20080730195637.2197a82d.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0807311156050.27055@sbz-30.cs.Helsinki.FI>
	 <1ba2fa240807310250kd2df7bfxa3591cf78e68f8dc@mail.gmail.com>
Date: Thu, 31 Jul 2008 12:53:14 +0300
Message-Id: <1217497994.7813.184.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-31 at 12:50 +0300, Tomas Winkler wrote:
> > There's ath5k in the stack trace but that, of course, doesn't
> > automatically mean it's at fault here. It could have been just the poor
> > bastard who was the next to allocate 4 KB with kmalloc() noticing the
> > corruption.
> >
> > Hope this helps!
> 
> I've seen something similar with fragmentation code in iwl4965 but I
> can reproduce it only when using SLAB. With SLUB it didn't shown up.
> Does anyone know what is difference between SLAB and SLUB in this context.?

Do you have CONFIG_SLUB_DEBUG_ON enabled? (Note: if you only have
CONFIG_SLUB_DEBUG enabled, then you need to enable debugging at run-time
by passing slub_debug to kernel command line.)

