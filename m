Return-Path: <linux-kernel-owner+w=401wt.eu-S1759157AbZCCADd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759157AbZCCADd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 19:03:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756158AbZCCADT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 19:03:19 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53833
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755322AbZCCADS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 19:03:18 -0500
Date: Mon, 02 Mar 2009 16:02:59 -0800 (PST)
Message-Id: <20090302.160259.26769832.davem@davemloft.net>
To: jeffrey.t.kirsher@intel.com
Cc: netdev@vger.kernel.org, gospo@redhat.com, stable@kernel.org,
       linux-kernel@vger.kernel.org, jesse.brandeburg@intel.com,
       bruce.w.allan@intel.com
Subject: Re: [net-next PATCH 1/2] e1000e: fix unmap bug
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090302234929.12507.51437.stgit@lost.foo-projects.org>
References: <20090302234929.12507.51437.stgit@lost.foo-projects.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Mon, 02 Mar 2009 15:49:29 -0800

> From: Jesse Brandeburg <jesse.brandeburg@intel.com>
> 
> This is in reference to https://bugzilla.redhat.com/show_bug.cgi?id=484494
> Also addresses issue show in kerneloops
> 
> The e1000e transmit code was calling pci_unmap_page on dma handles that it
> might have called pci_map_single on.
> 
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Acked-by: Bruce Allan <bruce.w.allan@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

Applied.
