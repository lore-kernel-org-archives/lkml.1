Return-Path: <linux-kernel-owner+w=401wt.eu-S1756756AbYGQJeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756AbYGQJeU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 05:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbYGQJeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 05:34:04 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:29926 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899AbYGQJeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 05:34:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VXb6YKi2M6afuWVh59y/d/YTLAsdDoAjjLN9vrD3plqnOjHDZIqN0VOvnKuNQHiDLq
         nD4KNSGXQaW8wSY7v42tRyrtFmqtWYgbWS/rTlpo3fuIsE61M7p8OUsnhT84kmN8/77L
         KZwWUXmi471lkuXpM+aG2b9sDL0Dal7YKJrjg=
Date: Thu, 17 Jul 2008 13:31:17 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: jie.yang@atheros.com
Cc: jeff@garzik.org, yjwei@cn.fujitsu.com, rdreier@cisco.com,
       shemminger@vyatta.com, davem@davemloft.net, jcliburn@gmail.com,
       parag.warudkar@gmail.com, w@1wt.eu, oliver.schuster@schweigstill.de,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] atl1e: Atheros L1E Gigabit Ethernet driver
Message-ID: <20080717093117.GA8373@martell.zuzino.mipt.ru>
References: <12162854952457-git-send-email-jie.yang@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12162854952457-git-send-email-jie.yang@atheros.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Full patch for the Atheros L1E Gigabit Ethernet driver.
> Supportring AR8121, AR8113 and AR8114

Does it have the same 4G limitation as ATL1 card?

If yes, pci_using_64 logic isn't needed, and copying comment from atl1 driver wouldn't hurt,
If no, you're setting small DMA mask.

