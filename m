Return-Path: <linux-kernel-owner+w=401wt.eu-S1759930AbZCCAEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759930AbZCCAEB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 19:04:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758624AbZCCADs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 19:03:48 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53839
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757082AbZCCADr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 19:03:47 -0500
Date: Mon, 02 Mar 2009 16:03:28 -0800 (PST)
Message-Id: <20090302.160328.123427174.davem@davemloft.net>
To: jeffrey.t.kirsher@intel.com
Cc: netdev@vger.kernel.org, gospo@redhat.com, stable@kernel.org,
       linux-kernel@vger.kernel.org, jesse.brandeburg@intel.com,
       bruce.w.allan@intel.com
Subject: Re: [net-next PATCH 2/2] e1000: fix unmap bug
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090302234953.12507.91320.stgit@lost.foo-projects.org>
References: <20090302234929.12507.51437.stgit@lost.foo-projects.org>
	<20090302234953.12507.91320.stgit@lost.foo-projects.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Mon, 02 Mar 2009 15:49:53 -0800

> From: Jesse Brandeburg <jesse.brandeburg@intel.com>
> 
> This is in reference to the issue shown in kerneloops (search e1000 unmap)
> 
> The e1000 transmit code was calling pci_unmap_page on dma handles that it
> might have called pci_map_single on.
> 
> Same bug as e1000e
> 
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Acked-by: Bruce Allan <bruce.w.allan@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

Also applied, thanks.
