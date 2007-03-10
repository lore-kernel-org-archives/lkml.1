Return-Path: <linux-kernel-owner+w=401wt.eu-S1767600AbXCJAHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767600AbXCJAHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 19:07:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767599AbXCJAHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 19:07:47 -0500
Received: from mtagate5.de.ibm.com ([195.212.29.154]:53096 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767600AbXCJAHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 19:07:46 -0500
Date: Sat, 10 Mar 2007 02:07:43 +0200
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dma_ops as const
Message-ID: <20070310000743.GI5059@rhun.ibm.com>
References: <20070309154640.7d01bf68@dxpl.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070309154640.7d01bf68@dxpl.pdx.osdl.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2007 at 03:46:40PM -0800, Stephen Hemminger wrote:
> The dma_ops structure can be const since it never changes
> after boot.

Sounds reasonable. I haven't come up with a likely case where we would
want to change a dma_ops structure (as opposed to just pointing to a
different structure) so ...

Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>

Cheers,
Muli
