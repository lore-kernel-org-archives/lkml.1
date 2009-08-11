Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbZHKNuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbZHKNuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 09:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621AbZHKNuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 09:50:39 -0400
Received: from gate.crashing.org ([63.228.1.57]:58847 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754565AbZHKNuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 09:50:39 -0400
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pierre Ossman <pierre@ossman.eu>, David Vrabel <david.vrabel@csr.com>,
       Ben Dooks <ben@fluff.org>, Sascha Hauer <s.hauer@pengutronix.de>,
       linux-kernel@vger.kernel.org, sdhci-devel@lists.ossman.eu,
       linuxppc-dev@ozlabs.org
Message-Id: <A17F24A0-87E0-4FFA-9C14-DF57D8A9D015@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
In-Reply-To: <20090807195822.GG2735@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: [PATCH 7/7] powerpc/85xx: Add eSDHC support for MPC8536DS boards
Date: Tue, 11 Aug 2009 08:48:32 -0500
References: <20090807195724.GA24020@oksana.dev.rtsoft.ru> <20090807195822.GG2735@oksana.dev.rtsoft.ru>
X-Mailer: Apple Mail (2.936)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 7, 2009, at 2:58 PM, Anton Vorontsov wrote:

> This patch simply adds sdhci node to the device tree.
>
> We specify clock-frequency manually, so that eSDHC will work without
> upgrading U-Boot. Though, that'll only work for default setup (1500
> MHz) on new board revisions. For non-default setups, it's recommended
> to upgrade U-Boot, since it will fixup clock-frequency automatically.
>
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---
> arch/powerpc/boot/dts/mpc8536ds.dts |    8 ++++++++
> 1 files changed, 8 insertions(+), 0 deletions(-)

Can you update the mpc8536ds_36b.dts as well (its in my next branch)

- k
