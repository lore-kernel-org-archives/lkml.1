Return-Path: <linux-kernel-owner+w=401wt.eu-S1751391AbZHSBZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391AbZHSBZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 21:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751152AbZHSBZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 21:25:58 -0400
Received: from gate.crashing.org ([63.228.1.57]:46722 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbZHSBZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 21:25:57 -0400
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pierre Ossman <pierre@ossman.eu>, David Vrabel <david.vrabel@csr.com>,
       Ben Dooks <ben@fluff.org>, Sascha Hauer <s.hauer@pengutronix.de>,
       linux-kernel@vger.kernel.org, sdhci-devel@lists.ossman.eu,
       linuxppc-dev@ozlabs.org
Message-Id: <F58A75CD-73CC-4F75-AF51-2BCC0B828E84@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: avorontsov@ru.mvista.com
In-Reply-To: <20090818233818.GA29042@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: [PATCH v2] powerpc/85xx: Add eSDHC support for MPC8536DS boards
Date: Tue, 18 Aug 2009 20:24:17 -0500
References: <20090807195724.GA24020@oksana.dev.rtsoft.ru> <20090807195822.GG2735@oksana.dev.rtsoft.ru> <A17F24A0-87E0-4FFA-9C14-DF57D8A9D015@kernel.crashing.org> <20090818233818.GA29042@oksana.dev.rtsoft.ru>
X-Mailer: Apple Mail (2.936)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 18, 2009, at 6:38 PM, Anton Vorontsov wrote:

> This patch simply adds sdhci node to the device tree.
>
> We specify clock-frequency manually, so that eSDHC will work without
> upgrading U-Boot. Though, that'll only work for default setup (1500
> MHz) on new board revisions. For non-default setups, it's recommended
> to upgrade U-Boot, since it will fixup clock-frequency automatically.
>
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>

out of interest the 85xx eSDHC don't need the sdhci,wp-inverted  
property?

- k
