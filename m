Return-Path: <linux-kernel-owner+w=401wt.eu-S1753098AbZBNLlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098AbZBNLlv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 06:41:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbZBNLlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 06:41:40 -0500
Received: from gir.skynet.ie ([193.1.99.77]:46974 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752706AbZBNLlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 06:41:39 -0500
Date: Sat, 14 Feb 2009 11:41:37 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Jerome Glisse <glisse@freedesktop.org>
cc: David Miller <davem@davemloft.net>, michel@daenzer.net,
       benh@kernel.crashing.org, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: drm: radeon: Use surface for PCI GART table.
In-Reply-To: <1234611311.2860.2.camel@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.0902141140560.13093@skynet.skynet.ie>
References: <20090214.015107.127190039.davem@davemloft.net>  <1234605599.4823.177.camel@thor>  <20090214.020431.193689843.davem@davemloft.net> <1234611311.2860.2.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> This will need to be revisited with KMS as i think we should not allow
> userspace to play with surface. Maybe we could setup surface on BO
> mapping and disable them on bo unmapping (we would to register some
> callback on vmclose).

Under KMS we can either enable swappers fulltime or just use surfaces and 
bar swapper setting from userspace which we do already.

Dave.
