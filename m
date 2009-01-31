Return-Path: <linux-kernel-owner+w=401wt.eu-S1753463AbZAaK7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbZAaK7R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 05:59:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbZAaK7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 05:59:00 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58971 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbZAaK67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 05:58:59 -0500
Date: Sat, 31 Jan 2009 10:58:48 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH F 10/12] OMAP2/3 clock: omap2_clk_enable(): fix logic
Message-ID: <20090131105848.GC1394@n2100.arm.linux.org.uk>
References: <20090128193326.2396.9437.stgit@localhost.localdomain> <20090128193525.2396.11744.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090128193525.2396.11744.stgit@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 12:35:28PM -0700, Paul Walmsley wrote:
> Rearrange the parent clock enable status check code so it actually makes
> sense.  No functional change.

I don't think there's anything gained from introducing the additional
'parent_ret' variable.
