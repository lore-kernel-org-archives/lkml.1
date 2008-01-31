Return-Path: <linux-kernel-owner+w=401wt.eu-S1757062AbYAaDAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062AbYAaDAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 22:00:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757869AbYAaDAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 22:00:23 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:52433 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757032AbYAaDAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 22:00:20 -0500
To: akepner@sgi.com
Cc: Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       David Miller <davem@davemloft.net>, Muli Ben-Yehuda <muli@il.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] IB: introducing MTHCA_MR_DMABARRIER
X-Message-Flag: Warning: May contain useful information
References: <20080130055429.GV30022@sgi.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 30 Jan 2008 19:00:11 -0800
In-Reply-To: <20080130055429.GV30022@sgi.com> (akepner@sgi.com's message of "Tue, 29 Jan 2008 21:54:29 -0800")
Message-ID: <adair1aaedg.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 31 Jan 2008 03:00:11.0735 (UTC) FILETIME=[65271670:01C863B5]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > @@ -72,6 +73,8 @@ static void __ib_umem_release(struct ib_device *dev, struct ib_umem *umem, int d
 >   * @addr: userspace virtual address to start at
 >   * @size: length of region to pin
 >   * @access: IB_ACCESS_xxx flags for memory being pinned
 > + * @dmabarrier: set a "dma barrier" so that in-flight DMA is 
 > + *  flushed when the memory region is written to
 >   */

I see... it seems some of the previous patch snuck in here...
