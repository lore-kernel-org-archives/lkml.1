Return-Path: <linux-kernel-owner+w=401wt.eu-S1755187AbZHYPd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbZHYPd5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 11:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754853AbZHYPd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 11:33:56 -0400
Received: from smtp4.ultrahosting.com ([74.213.175.253]:38415 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754836AbZHYPdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 11:33:55 -0400
X-Greylist: delayed 582 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Aug 2009 11:33:55 EDT
Date: Tue, 25 Aug 2009 11:23:51 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Mike Galbraith <efault@gmx.de>
cc: raz ben yehuda <raziebe@gmail.com>, riel@redhat.com, mingo@elte.hu,
       peterz@infradead.org, andrew motron <akpm@linux-foundation.org>,
       wiseman@macs.biu.ac.il, lkml <linux-kernel@vger.kernel.org>,
       linux-rt-users@vger.kernel.org
Subject: Re: RFC: THE OFFLINE SCHEDULER
In-Reply-To: <1251021133.14003.172.camel@marge.simson.net>
Message-ID: <alpine.DEB.1.10.0908251122020.26329@gentwo.org>
References: <1250983671.5688.21.camel@raz>  <1251004897.7043.70.camel@marge.simson.net>  <1251018551.3810.35.camel@raz>  <1251012621.14003.71.camel@marge.simson.net> <1251025557.3810.65.camel@raz> <1251021133.14003.172.camel@marge.simson.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Aug 2009, Mike Galbraith wrote:

> The rest, I'll leave off replying to, we're kinda splitting hairs.  I
> don't see a big generic benefit to OFFSCHED or ilk, others do.

No we are not splitting hairs. OFFSCHED takes the OS noise (interrupts,
timers, RCU, cacheline stealing etc etc) out of certain processors. You
cannot run an undisturbed piece of software on the OS right now.


