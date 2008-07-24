Return-Path: <linux-kernel-owner+w=401wt.eu-S1756817AbYGXL5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817AbYGXL5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 07:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbYGXL5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 07:57:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:36964 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbYGXL5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 07:57:21 -0400
Subject: Re: 22bb1be4d27... breaks hal (and NM)
From: Peter Zijlstra <peterz@infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>,
       "John W. Linville" <linville@tuxdriver.com>,
       Jean Tourrilhes <jt@hpl.hp.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1216899520.13587.49.camel@johannes.berg>
References: <20080724115805.5466c217@mjolnir.drzeus.cx>
	 <1216899520.13587.49.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 24 Jul 2008 13:57:11 +0200
Message-Id: <1216900631.7257.321.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-24 at 13:38 +0200, Johannes Berg wrote:
> On Thu, 2008-07-24 at 11:58 +0200, Pierre Ossman wrote:
> > From commit 22bb1be4d27...:
> > 
> > "The /sys/class/net/*/wireless/ direcory is, as far as I know, not used
> > by anyone."
> > 
> > Can't have been much of an investigation as HAL uses these to determine
> > if a card is a wireless one. Without this option, you cannot get
> > wireless support in NetworkManager, stranding most laptops.
> 
> Bzzzzt. You suck. Go check again. Hint: try hal's git tree.

So you're not considering HAL as shipped by most (if not all) distros as
anyone?

If everybody would act like that, the next kernel wouldn't even manage
to get rudimentary user-space up and running. Like we already changed
all those systemcalls in glibc-head, who needs this kernel to boot on
your old stuff anyway..

Common,.. this is rediculous.

