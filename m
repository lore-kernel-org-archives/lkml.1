Return-Path: <linux-kernel-owner+w=401wt.eu-S965773AbZLHSCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965773AbZLHSCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 13:02:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936856AbZLHSCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 13:02:19 -0500
Received: from cantor.suse.de ([195.135.220.2]:45839 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936848AbZLHSCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 13:02:18 -0500
Date: Tue, 8 Dec 2009 09:54:10 -0800
From: Greg KH <gregkh@suse.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Anton Blanchard <anton@samba.org>
Subject: Re: [080/119] sched: Fix boot crash by zalloc()ing most of the cpu
 masks
Message-ID: <20091208175410.GA27061@suse.de>
References: <20091206235936.208334321@mini.kroah.org>
 <20091207000654.821385285@mini.kroah.org>
 <200912081209.51984.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912081209.51984.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08, 2009 at 12:09:51PM +1030, Rusty Russell wrote:
> On Mon, 7 Dec 2009 10:30:56 am Greg KH wrote:
> > 2.6.31-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > From: Rusty Russell <rusty@rustcorp.com.au>
> > 
> > commit 49557e620339cb134127b5bfbcfecc06b77d0232 upstream.
> > 
> > I got a boot crash when forcing cpumasks offstack on 32 bit,
> > because find_new_ilb() returned 3 on my UP system (nohz.cpu_mask
> > wasn't zeroed).
> 
> Please also include "bdddd2963c0264c56f18043f6fa829d3c1d3d1c0"
> (sched: Fix isolcpus boot option) from Linus' tree which fixes
> a regression this introduces.

Now queued up.

thanks,

greg k-h
