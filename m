Return-Path: <linux-kernel-owner+w=401wt.eu-S1758800AbZD0WS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800AbZD0WS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 18:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754899AbZD0WSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 18:18:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40649 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059AbZD0WSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 18:18:46 -0400
Date: Tue, 28 Apr 2009 00:22:42 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Styner, Douglas W" <douglas.w.styner@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
       "Ma, Chinang" <chinang.ma@intel.com>,
       "willy@linux.intel.com" <willy@linux.intel.com>
Subject: Re: Discrepancies between Oprofile and vmstat II
Message-ID: <20090427222242.GJ27382@one.firstfloor.org>
References: <D7C42C27E6CB1E4D8CBDF2F81EA92A260345836A3A@azsmsx501.amr.corp.intel.com> <87ljpmk29b.fsf@basil.nowhere.org> <D7C42C27E6CB1E4D8CBDF2F81EA92A26034598724F@azsmsx501.amr.corp.intel.com> <20090427185305.GG27382@one.firstfloor.org> <D7C42C27E6CB1E4D8CBDF2F81EA92A2603459877BD@azsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D7C42C27E6CB1E4D8CBDF2F81EA92A2603459877BD@azsmsx501.amr.corp.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 03:15:27PM -0700, Styner, Douglas W wrote:
> 
> > I believe so, but will confirm.
> >
> > > opcontrol -e=CPU_CLK_UNHALTED:80000 -e=LLC_MISSES:6000
> > > 
> > > Using another profiling tool to confirm, we see 74.784% user, 25.174% > > kernel.
> >
> > Just verifying -- you also see it when you use a shorter period than 80000 > right?
> 
> Confirmed.  Changes in profile appear to be due to increased sampling by oprofile with lower value.

You mean "with higher value", right ?

It's still strange that it suddenly changed in 2.6.27 though. There shouldn't have been
a difference there. So I still think it's a regression.

-Andi
