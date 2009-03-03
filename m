Return-Path: <linux-kernel-owner+w=401wt.eu-S1759050AbZCCQq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759050AbZCCQq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 11:46:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755381AbZCCQqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 11:46:08 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:32883 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755704AbZCCQqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 11:46:07 -0500
Date: Tue, 3 Mar 2009 16:45:49 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Walmsley <paul@pwsan.com>
Cc: "Woodruff, Richard" <r-woodruff2@ti.com>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH E 11/14] OMAP clock: track child clocks
Message-ID: <20090303164548.GD11096@n2100.arm.linux.org.uk>
References: <20090128192551.29333.82943.stgit@localhost.localdomain> <20090128192756.29333.41541.stgit@localhost.localdomain> <20090129151401.GC18233@n2100.arm.linux.org.uk> <20090129220608.GJ18233@n2100.arm.linux.org.uk> <20090219121932.GL6407@n2100.arm.linux.org.uk> <13B9B4C6EF24D648824FF11BE896716203772C3680@dlee02.ent.ti.com> <20090223160349.GB27688@n2100.arm.linux.org.uk> <alpine.DEB.2.00.0903021558360.30037@utopia.booyaka.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903021558360.30037@utopia.booyaka.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 02, 2009 at 04:02:14PM -0700, Paul Walmsley wrote:
> Suggest returning a more specific error than -EINVAL:
> 
> if (clk->usecount > 0)
>         return -EBUSY;

Done.
