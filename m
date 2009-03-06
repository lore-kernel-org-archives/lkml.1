Return-Path: <linux-kernel-owner+w=401wt.eu-S1756479AbZCFXBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479AbZCFXBY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 18:01:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbZCFXBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 18:01:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38311 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751803AbZCFXBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 18:01:14 -0500
Date: Fri, 6 Mar 2009 15:00:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: cooloney@kernel.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, sonic.zhang@analog.com
Subject: Re: [PATCH 04/18] Blackfin Serial Driver: Change hardware
 flowcontrol  from poll to interrupt driven.
Message-Id: <20090306150056.1bfa6d1f.akpm@linux-foundation.org>
In-Reply-To: <8bd0f97a0903061449w66c672a7r5197a175b16c61a4@mail.gmail.com>
References: <1236321780-28718-1-git-send-email-cooloney@kernel.org>
	<1236321780-28718-5-git-send-email-cooloney@kernel.org>
	<20090306143806.3b126ab4.akpm@linux-foundation.org>
	<8bd0f97a0903061449w66c672a7r5197a175b16c61a4@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Mar 2009 17:49:13 -0500
Mike Frysinger <vapier.adi@gmail.com> wrote:

> On Fri, Mar 6, 2009 at 17:38, Andrew Morton wrote:
> > On Fri, __6 Mar 2009 14:42:46 +0800 Bryan Wu wrote:
> >> From: Sonic Zhang <sonic.zhang@analog.com>
> >>
> >> Only CTS bit is affected.
> >>
> >> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> >> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> >
> > Another completely useless changelog.
> 
> the summary, while brief, describes the change: the flowcontrol is
> currently implemented by polling, but this changes it to an interrupt
> based system

yes, but it doesn't explain why the change was made.

> > Your [PATCH 00/18] email described all these patches as
> > needed-in-2.6.29 bugfixes. __As far as I can tell (based on almost zero
> > information), this patch is not a bugfix.
> 
> because the current implementation is polling (busy waiting), the
> kernel will basically hang when the remote asserts hardware
> flowcontrol pins.  if this is only asserted for short periods (less
> than 1 char time), then it's not really noticed ... but it still
> destroys latencies.

That.

Please send through replacement changelogs for all the patches which I
complained about.  Then I'll pick through it all and see what we can do
about a 2.6.29 merge.


