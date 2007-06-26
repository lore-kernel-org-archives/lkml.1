Return-Path: <linux-kernel-owner+w=401wt.eu-S1758225AbXFZQwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225AbXFZQwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 12:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756382AbXFZQwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 12:52:08 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:60557 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756389AbXFZQwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 12:52:07 -0400
Date: Tue, 26 Jun 2007 18:52:05 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Trilok Soni <soni.trilok@gmail.com>
Cc: linux-fbdev-devel@lists.sourceforge.net, adaplas@gmail.com,
       akpm@linux-foundation.org, Tony Lindgren <tony@atomide.com>,
       imre.deak@solidboot.com, juha.yrjola@solidboot.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/17] OMAP: Add TI OMAP1610 accelerator entry.
Message-ID: <20070626165205.GB22389@uranus.ravnborg.org>
References: <5d5443650706260534k5d6aca34k9f574b6ffddf85b2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d5443650706260534k5d6aca34k9f574b6ffddf85b2@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Your patch ordering is bad.
Patch 1 uses the symbol: FB_ACCEL_OMAP1610
but it is defined by patch 2.

Please reorder patches so the module compiles for each
and every patch being applied.

In this way you do not break git bisect for example.

	Sam
