Return-Path: <linux-kernel-owner+w=401wt.eu-S1756019AbYJPJgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbYJPJgY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 05:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbYJPJgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 05:36:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51781
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751886AbYJPJgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 05:36:11 -0400
Date: Thu, 16 Oct 2008 02:35:47 -0700 (PDT)
Message-Id: <20081016.023547.73315545.davem@davemloft.net>
To: jgarzik@pobox.com
Cc: mattilinn@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v1.2.34] WAN: merge driver retina
From: David Miller <davem@davemloft.net>
In-Reply-To: <48F70A90.4080007@pobox.com>
References: <48CC57EB.9010500@pobox.com>
	<ca0148c30809300251y37070034m20efd3e65caa868e@mail.gmail.com>
	<48F70A90.4080007@pobox.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jgarzik@pobox.com>
Date: Thu, 16 Oct 2008 05:34:08 -0400

> Matti Linnanvuori wrote:
> > 2008/9/14 Jeff Garzik <jgarzik@pobox.com>:
> >> Changes look good, but do not apply to the 'retina' branch.  Also, the
> >> virt_to_bus/virt_to_phys stuff should be replaced with DMA mapping API
> >> usage.
> > Actually there is one call of virt_to_phys in the patch I sent.
> > I don't know any way to replace virt_to_phys and still use remap_pfn_range.
> > If all architectures support virt_to_phys, I see no reason to replace it with
> > something else. The driver is legacy.
> 
> We do not merge new drivers that use deprecated APIs.
> 
> The whole point of a deprecated API is that you wish to remove it eventually.

Note that virt_to_phys() is not a problem.

It's only virt_to_bus() that mustn't be used.

