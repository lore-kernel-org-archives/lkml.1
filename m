Return-Path: <linux-kernel-owner+w=401wt.eu-S1753975Ab0ATSK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab0ATSK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 13:10:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753933Ab0ATSK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 13:10:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45754 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752003Ab0ATSKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 13:10:53 -0500
Date: Wed, 20 Jan 2010 10:09:36 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: David Miller <davem@davemloft.net>, Michael Breuer <mbreuer@majjas.com>,
       akpm@linux-foundation.org, flyboy@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Michael Chan <mchan@broadcom.com>, Don Fry <pcnet32@verizon.net>,
       Francois Romieu <romieu@fr.zoreil.com>,
       Matt Carlson <mcarlson@broadcom.com>
Subject: Re: [PATCH] sky2: Fix WARNING: at lib/dma-debug.c:902 check_sync
Message-ID: <20100120100936.16e10507@nehalam>
In-Reply-To: <20100120094103.GA6225@ff.dom.local>
References: <20100120094103.GA6225@ff.dom.local>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jan 2010 09:41:03 +0000
Jarek Poplawski <jarkao2@gmail.com> wrote:

> It seems using the same length (even without pci_unmap_len()) is
> crucial here, but I hope maintainers (added to CC) will take care.
> 
> Btw, it's not tested yet, but it might affect CONFIG_DMAR problems.
> 
> Thanks,
> Jarek P.

Update Documentation/PCI-DMA-mapping as well please.

-- 
