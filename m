Return-Path: <linux-kernel-owner+w=401wt.eu-S934288AbZKXVvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934288AbZKXVvv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:51:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933984AbZKXVvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:51:50 -0500
Received: from outbound-mail-137.bluehost.com ([67.222.39.27]:48974 "HELO
	outbound-mail-137.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933968AbZKXVvt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:51:49 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=NpZmZsqkc8F1sKh/HhRBFZZi5Y9cDnSc82HSwgDLMCeLRCo9ja7WG2IMVEzbmcdtBixYISJu31nH0/dFU7QKzVq5RSoxJ1bxQWWHsbFNzyGbsqGYNOHh8b9cq1ZXRSpL;
Date: Tue, 24 Nov 2009 13:51:50 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "=?UTF-8?B?QW5kcsOp?= Goddard Rosa" <andre.goddard@gmail.com>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: linux-next: manual merge of the trivial tree with the pci tree
Message-ID: <20091124135150.0ccfd366@jbarnes-piketon>
In-Reply-To: <alpine.LSU.2.00.0911172318340.15039@wotan.suse.de>
References: <20091117155417.e0514040.sfr@canb.auug.org.au>
	<alpine.LSU.2.00.0911172318340.15039@wotan.suse.de>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Nov 2009 23:19:53 +0100 (CET)
Jiri Kosina <jkosina@suse.cz> wrote:

> On Tue, 17 Nov 2009, Stephen Rothwell wrote:
> 
> > Today's linux-next merge of the trivial tree got a conflict in
> > arch/x86/pci/amd_bus.c between commit
> > 99935a7a59eaca0292c1a5880e10bae03f4a5e3d ("x86/PCI: read root
> > resources from IOH on Intel") from the pci tree and commit
> > 17530b1c635dfd1f258afc6b07b986b425d66ebd ("tree-wide: fix assorted
> > typos all over the place") from the trivial tree.
> > 
> > The comment fixed up by the trivial tree patch has moved to
> > arch/x86/pci/bus_numa.h and I haven't bothered to fix it there.
> 
> Thanks for letting me know.
> 
> I have dropped the hunk from my queue. Jesse, could you please merge
> this patch to your tree instead?
> 
> 
> 
> 
> From: André Goddard Rosa <andre.goddard@gmail.com>
> Subject: pci: fix comment typo
> 
> Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> 
> diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
> index 572ee97..575f6fe 100644
> --- a/arch/x86/pci/amd_bus.c
> +++ b/arch/x86/pci/amd_bus.c
> @@ -19,7 +19,7 @@
>  /*
>   * sub bus (transparent) will use entres from 3 to store extra from
> root,
> - * so need to make sure have enought slot there, increase
> PCI_BUS_NUM_RESOURCES?
> + * so need to make sure have enough slot there, increase
> PCI_BUS_NUM_RESOURCES? */
>  #define RES_NUM 16

Fixed this up.  The comment is in bus_numa.h now.

-- 
Jesse Barnes, Intel Open Source Technology Center
