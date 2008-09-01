Return-Path: <linux-kernel-owner+w=401wt.eu-S1757400AbYIAKBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400AbYIAKBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 06:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbYIAKB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 06:01:29 -0400
Received: from smtp.nokia.com ([192.100.122.233]:26874 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbYIAKB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 06:01:28 -0400
Date: Mon, 1 Sep 2008 13:00:21 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Bryan Wu <cooloney@kernel.org>
Cc: David Brownell <david-b@pacbell.net>,
       Felipe Balbi <felipebalbi@users.sourceforge.net>,
       Felipe Balbi <felipe.balbi@nokia.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: HAVE_CLK (for <linux/clk.h> support)
Message-ID: <20080901100021.GB7041@gandalf.research.nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <200805231044.59969.david-b@pacbell.net> <200805271614.55233.david-b@pacbell.net> <31e679430805271701h73ee1eb2p80329900008827f8@mail.gmail.com> <200805271841.16793.david-b@pacbell.net> <386072610809010248l78e9c661i130c3fa4b84b0a3c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <386072610809010248l78e9c661i130c3fa4b84b0a3c@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 01 Sep 2008 10:00:24.0097 (UTC) FILETIME=[8D4AB910:01C90C19]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2008 at 05:48:14PM +0800, ext Bryan Wu wrote:
> Sorry for jumping in so later. I noticed Blackfin does not support
> HAVE_CLK currently.
> As the HAVE_CLK dependence is included in the kernel mainline, MUSB
> parts do not show up in the Kconfig because of lacking of HAVE_CLK.
> 
> To implement clk infrastructure in Blackfin will be later than merging
> MUSB Blackfin parts to upstream.
> 
> Any idea?

dude, you're really late on this one. Now that musb depends on HAVE_CLK
and we have things working for that. What you can do is locally (on your
tree) remove the HAVE_CLK dependency so you can keep musb development
going. But don't push that patch upstream. Meanwhile, you'll have time
to implement clk framework support for blackfin.

-- 
balbi
