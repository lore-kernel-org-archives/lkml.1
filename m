Return-Path: <linux-kernel-owner+w=401wt.eu-S1761358AbZFPCnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761358AbZFPCnZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 22:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbZFPCnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 22:43:17 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:41376 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbZFPCnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 22:43:17 -0400
Subject: Re: [PATCH] clocksource: setup mult_orig in clocksource_enable()
From: john stultz <johnstul@us.ibm.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, lethal@linux-sh.org,
       tglx@linutronix.de, akpm@linux-foundation.org
In-Reply-To: <1245092917.7505.4.camel@localhost.localdomain>
References: <20090501054546.8193.10688.sendpatchset@rx1.opensource.se>
	 <1244667895.8085.20.camel@localhost.localdomain>
	 <aec7e5c30906102251n36bbe6f9x9b384131f332d4d9@mail.gmail.com>
	 <1244850967.7231.26.camel@localhost.localdomain>
	 <aec7e5c30906140320r4d24c9efqb2bc2e30d715de02@mail.gmail.com>
	 <1245092917.7505.4.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 15 Jun 2009 19:42:56 -0700
Message-Id: <1245120176.7505.39.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-15 at 12:08 -0700, john stultz wrote:
> On Sun, 2009-06-14 at 19:20 +0900, Magnus Damm wrote:
> > On Sat, Jun 13, 2009 at 8:56 AM, john stultz<johnstul@us.ibm.com> wrote:
> > > So yea, at a minimum setting mult back to orig_mult would be needed for
> > > this patch to work.
> > 
> > Want me to write a patch for it, or do you prefer to handle it yourself?
> 
> You should submit it. Its just a tweak on your prior patch.

So Linus already merged your patch that breaks mult_orig, so fixing this
is a bit more of a priority. Let me know if you have the cycles to fix
it and if not I'll take a swing at it.

thanks
-john


