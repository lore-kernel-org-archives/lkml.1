Return-Path: <linux-kernel-owner+w=401wt.eu-S1762138AbYEARXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762138AbYEARXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 13:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758134AbYEARX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 13:23:26 -0400
Received: from outbound-mail-114.bluehost.com ([69.89.24.4]:55899 "HELO
	outbound-mail-114.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751707AbYEARX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 13:23:26 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH 0/3] Add API for weak DMA masks
Date: Thu, 1 May 2008 10:22:55 -0700
User-Agent: KMail/1.9.9
Cc: Christoph Hellwig <hch@infradead.org>,
       John Linville <linville@tuxdriver.com>,
       Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <200805011638.15910.mb@bu3sch.de> <200805010930.04799.jbarnes@virtuousgeek.org> <200805011916.07340.mb@bu3sch.de>
In-Reply-To: <200805011916.07340.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805011022.55390.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 01, 2008 10:16 am Michael Buesch wrote:
> Ok, will redo the patches with that added and the name changed.
>
> > Most drivers just do the fallback themselves, right?
>
> Right.
>
> > So it makes sense to
> > just update the current code to fallback, and update drivers wanting
> > specific mask values to check afterwards.  I hate to inflict that kind of
> > driver wide update on Michael though... :)
>
> Well, that's a lot of work and I'm not sure it's worth it.
> I could live with having dma_set_mask as an API that fails on bad masks
> and dma_request_mask as an API above that which retries. I think that's
> just fine. Drivers can be migrated over time to the new API (or not. That
> can be the driver maintainer's choice).

Can you also update the docs with the new call, indicating that it should 
probably used in all but special cases?

Thanks,
Jesse
