Return-Path: <linux-kernel-owner+w=401wt.eu-S933856AbZJGBqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933856AbZJGBqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 21:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754012AbZJGBqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 21:46:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:54234 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753938AbZJGBqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 21:46:17 -0400
Message-ID: <4ACBF2BF.5060707@kernel.org>
Date: Wed, 07 Oct 2009 10:45:35 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: pci tree build failure
References: <20091007123821.043465c6.sfr@canb.auug.org.au>
In-Reply-To: <20091007123821.043465c6.sfr@canb.auug.org.au>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 07 Oct 2009 01:45:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi Jesse,
> 
> Today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> ERROR: "pci_set_cacheline_size" [drivers/pcmcia/pcmcia_core.ko] undefined!
> 
> Caused by commit 018bc96e8e27bfcafec9357ff370bf51241a7ea7 ("pccard:
> configure CLS on attach") which neglected to EXPORT_SYMBOL
> pci_set_cacheline_size.
> 
> I have used the version of the pci tree from next-20091006 for today.
> 

Oops, Jesse, can you please add EXPORT_SYMBOL_GPL() there?

Thanks.

-- 
tejun
