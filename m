Return-Path: <linux-kernel-owner+w=401wt.eu-S1762394AbYBAC7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762394AbYBAC7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 21:59:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbYBAC64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 21:58:56 -0500
Received: from relay1.sgi.com ([192.48.171.29]:40184 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752509AbYBAC64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 21:58:56 -0500
From: akepner@sgi.com
Date: Thu, 31 Jan 2008 18:57:28 -0800
To: Roland Dreier <rdreier@cisco.com>
Cc: Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       David Miller <davem@davemloft.net>, Muli Ben-Yehuda <muli@il.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] IB: introducing MTHCA_MR_DMABARRIER
Message-ID: <20080201025728.GA28899@sgi.com>
References: <20080130055429.GV30022@sgi.com> <adair1aaedg.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adair1aaedg.fsf@cisco.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 07:00:11PM -0800, Roland Dreier wrote:
>  > @@ -72,6 +73,8 @@ static void __ib_umem_release(struct ib_device *dev, struct ib_umem *umem, int d
>  >   * @addr: userspace virtual address to start at
>  >   * @size: length of region to pin
>  >   * @access: IB_ACCESS_xxx flags for memory being pinned
>  > + * @dmabarrier: set a "dma barrier" so that in-flight DMA is 
>  > + *  flushed when the memory region is written to
>  >   */
> 
> I see... it seems some of the previous patch snuck in here...

I'll break the next patchset up differently, and also include 
mlx4.

-- 
Arthur

