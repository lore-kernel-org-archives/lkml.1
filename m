Return-Path: <linux-kernel-owner+w=401wt.eu-S1754155AbYCILSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbYCILSe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 07:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbYCILS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 07:18:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40766 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752517AbYCILS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 07:18:26 -0400
Subject: Re: [UPDATED v3][PATCH 4/7] regulator: framework core
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <20080308103008.5ecbdc7e.akpm@linux-foundation.org>
References: <1204827115.15360.150.camel@a10323.wolfsonmicro.main>
	 <20080307003910.72fb8043.akpm@linux-foundation.org>
	 <1204997086.13653.48.camel@localhost.localdomain>
	 <20080308103008.5ecbdc7e.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sun, 09 Mar 2008 11:18:23 +0000
Message-Id: <1205061503.13653.120.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-03-08 at 10:30 -0800, Andrew Morton wrote:
> On Sat, 08 Mar 2008 17:24:46 +0000 Liam Girdwood <lg@opensource.wolfsonmicro.com> wrote:
> 
> > > Should be indented with a tab, not spacespacespacespace
> > 
> > This patch releases the lock in get_device_regulator(), makes
> > get_lowest_stable_voltage() non inline and fixes a minor indentation
> > issue.
> 
> OK, I'll toss it in there, thanks.
> 
> It sounds like significant changes will be happening and that we can expect
> to see a new patchset?
> 

Yep, I have some customer stuff to do at the start of the week so I'll
be able to send some new patches later in the week. 

> I assume you noted my s/get_current/read_current/g fix?  It'll be needed for
> alpha, frv and mn10300.  read_current() is a pretty crappy name but I couldn't
> think of anything better.  It would look nicer if we also did
> s/get_voltage/read_voltage/g - your call.

ok, will do.

Liam

