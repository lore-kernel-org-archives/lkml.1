Return-Path: <linux-kernel-owner+w=401wt.eu-S934133AbZJGPkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934133AbZJGPkj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 11:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933285AbZJGPki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 11:40:38 -0400
Received: from outbound-mail-23.bluehost.com ([69.89.21.18]:37184 "HELO
	outbound-mail-23.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933367AbZJGPkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 11:40:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Hb9J+MafCv6chLbJd80wLvhlG9D7pCMN7UctHPy8a8hkRu3ylS5ZD1EoeELHmm4EPIUaHO9r3d0U9efMWgMc4Qoq9R/6Zz/Sw9kkfuXpIOt7jKtkYHQTl9DHa6s6ffI0;
Date: Wed, 7 Oct 2009 08:39:44 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Tejun Heo <tj@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: pci tree build failure
Message-ID: <20091007083944.0d0d5059@jbarnes-g45>
In-Reply-To: <4ACBF2BF.5060707@kernel.org>
References: <20091007123821.043465c6.sfr@canb.auug.org.au>
	<4ACBF2BF.5060707@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Oct 2009 10:45:35 +0900
Tejun Heo <tj@kernel.org> wrote:

> Stephen Rothwell wrote:
> > Hi Jesse,
> > 
> > Today's linux-next build (x86_64 allmodconfig) failed like this:
> > 
> > ERROR: "pci_set_cacheline_size" [drivers/pcmcia/pcmcia_core.ko]
> > undefined!
> > 
> > Caused by commit 018bc96e8e27bfcafec9357ff370bf51241a7ea7 ("pccard:
> > configure CLS on attach") which neglected to EXPORT_SYMBOL
> > pci_set_cacheline_size.
> > 
> > I have used the version of the pci tree from next-20091006 for
> > today.
> > 
> 
> Oops, Jesse, can you please add EXPORT_SYMBOL_GPL() there?

Sure, sorry I missed it.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
