Return-Path: <linux-kernel-owner+w=401wt.eu-S1753246AbYCHScT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246AbYCHScT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 13:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756137AbYCHScB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 13:32:01 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38514 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752945AbYCHScA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 13:32:00 -0500
Date: Sat, 8 Mar 2008 10:30:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Cc: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [UPDATED v3][PATCH 4/7] regulator: framework core
Message-Id: <20080308103008.5ecbdc7e.akpm@linux-foundation.org>
In-Reply-To: <1204997086.13653.48.camel@localhost.localdomain>
References: <1204827115.15360.150.camel@a10323.wolfsonmicro.main>
	<20080307003910.72fb8043.akpm@linux-foundation.org>
	<1204997086.13653.48.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 08 Mar 2008 17:24:46 +0000 Liam Girdwood <lg@opensource.wolfsonmicro.com> wrote:

> > Should be indented with a tab, not spacespacespacespace
> 
> This patch releases the lock in get_device_regulator(), makes
> get_lowest_stable_voltage() non inline and fixes a minor indentation
> issue.

OK, I'll toss it in there, thanks.

It sounds like significant changes will be happening and that we can expect
to see a new patchset?

I assume you noted my s/get_current/read_current/g fix?  It'll be needed for
alpha, frv and mn10300.  read_current() is a pretty crappy name but I couldn't
think of anything better.  It would look nicer if we also did
s/get_voltage/read_voltage/g - your call.
