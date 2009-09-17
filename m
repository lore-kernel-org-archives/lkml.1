Return-Path: <linux-kernel-owner+w=401wt.eu-S1758657AbZIQQiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758657AbZIQQiD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 12:38:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758501AbZIQQiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 12:38:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:37640 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754661AbZIQQiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 12:38:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,404,1249282800"; 
   d="scan'208";a="449385647"
Date: Thu, 17 Sep 2009 09:37:59 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: Disable AER with pci=nomsi
Message-ID: <20090917093759.617ffcba@jbarnes-g45>
In-Reply-To: <20090916204022.GA30729@basil.fritz.box>
References: <20090916204022.GA30729@basil.fritz.box>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Sep 2009 22:40:22 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> PCI: Disable AER with pci=nomsi
> 
> When booting with pci=nomsi aer causes lost interrupts and
> lockdep inversions.
> 
> So check if MSIs are not disabled before initializing the aer
> driver.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Applied to my linux-next tree for the next pull.  Thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
