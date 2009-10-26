Return-Path: <linux-kernel-owner+w=401wt.eu-S1756270AbZJZUkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270AbZJZUkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 16:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756196AbZJZUkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 16:40:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:48671 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753749AbZJZUkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 16:40:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,628,1249282800"; 
   d="scan'208";a="563567234"
Date: Mon, 26 Oct 2009 13:40:13 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH pci-2.6#linux-next] pci: pci_dfl_cache_line_size is
 __devinitdata
Message-ID: <20091026134013.43a50cb2@jbarnes-g45>
In-Reply-To: <4ACDB819.4060606@kernel.org>
References: <20091008152725.1351485a.sfr@canb.auug.org.au>
	<4ACDB819.4060606@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Oct 2009 18:59:53 +0900
Tejun Heo <tj@kernel.org> wrote:

> pci_dfl_cache_line_size is marked as __initdata but referenced by
> pci_init() which is __devinit.  Make it __devinitdata instead of
> __initdata.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---

Applied to my linux-next tree, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
