Return-Path: <linux-kernel-owner+w=401wt.eu-S1754608AbYGCUXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbYGCUXn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 16:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbYGCUXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 16:23:34 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:56696 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752207AbYGCUXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 16:23:33 -0400
Date: Thu, 3 Jul 2008 21:22:50 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       tony@atomide.com, paul@pwsan.com, David Brownell <david-b@pacbell.net>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>, ian <spyro@f2s.com>
Subject: Re: [PATCH 0/3] Clocklib: generic framework for clocks managing
	[v3]
Message-ID: <20080703202250.GA24620@fluff.org.uk>
References: <20080626125033.GA7093@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080626125033.GA7093@doriath.ww600.siemens.net>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 04:50:33PM +0400, Dmitry Baryshkov wrote:
> Hi,
> 
> This is again a set of patches to unify the management of clocks and
> allow easy registration and unregistration of them. This is neccessary
> to cleanly support such devices as toshiba mobile companion chips,
> sa1111 companion, etc. Also it brings code unification, especially for a
> lot of arm sub-arches which share nearly the same code, etc.
> 
> This is the "version 3" approach. Given the negative response to
> kobjects, I've redesigned it to use plain krefs.
> 
> Debugfs support is merged into main clocklib patch. Documentation
> for it's interface will come later. For now it provides tree structure
> with single file per each clock directory.

I'd prefer not to see this called clocklib, it isn't of any use
outside of the kernel, and once it is in there's little point in
anyone not using it.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
