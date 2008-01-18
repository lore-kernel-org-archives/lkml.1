Return-Path: <linux-kernel-owner+w=401wt.eu-S1758070AbYARBSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070AbYARBSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 20:18:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757451AbYARBSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 20:18:14 -0500
Received: from waste.org ([66.93.16.53]:38421 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993AbYARBSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 20:18:13 -0500
Subject: Re: 2.6.24-rc8-mm1: powerpc oopses
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: m.kozlowski@tuxland.pl, linux-kernel@vger.kernel.org, paulus@samba.org,
       linuxppc-dev@ozlabs.org
In-Reply-To: <20080117170754.b5dd139b.akpm@linux-foundation.org>
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
	 <200801172315.28129.m.kozlowski@tuxland.pl>
	 <20080117145105.ad968ea6.akpm@linux-foundation.org>
	 <1200613194.3839.22.camel@cinder.waste.org>
	 <20080117160513.3456b4eb.akpm@linux-foundation.org>
	 <1200615168.3839.26.camel@cinder.waste.org>
	 <20080117162913.0323c517.akpm@linux-foundation.org>
	 <1200617237.3839.32.camel@cinder.waste.org>
	 <20080117170754.b5dd139b.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 17 Jan 2008 19:16:50 -0600
Message-Id: <1200619010.13504.2.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-17 at 17:07 -0800, Andrew Morton wrote:
> That worked out nicely.

Cool, feel free to add:

Signed-off-by: Matt Mackall <mpm@selenic.com>

> Wasn't the old code potentially pte_unmap()ping the wrong address?  If we
> enter with addr==end?

Yes, that was busted.

-- 
Mathematics is the supreme nostalgia of our time.

