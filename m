Return-Path: <linux-kernel-owner+w=401wt.eu-S1754252Ab0ADXst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252Ab0ADXst (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 18:48:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230Ab0ADXsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 18:48:47 -0500
Received: from outbound-mail-141.bluehost.com ([67.222.38.31]:51818 "HELO
	outbound-mail-141.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754224Ab0ADXsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 18:48:46 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=N3J/dHuvqgQZvUVY/0FFx6Tal+vm8ItVEgailJU9MsmlRhjb7aP+UKbcIxdHOj3Ce1LIha9tFbOu+4mwJYHkzv5gTXxX/Knlq/gPno8YB305Ci1MdO/84sBpXStfvBnE;
Date: Mon, 4 Jan 2010 15:48:43 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: pci tree build failure
Message-ID: <20100104154843.294c06ff@jbarnes-piketon>
In-Reply-To: <20100104231001.GF9882@parisc-linux.org>
References: <20100105095543.8c446cb7.sfr@canb.auug.org.au>
	<20100104231001.GF9882@parisc-linux.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jan 2010 16:10:01 -0700
Matthew Wilcox <matthew@wil.cx> wrote:

> On Tue, Jan 05, 2010 at 09:55:43AM +1100, Stephen Rothwell wrote:
> > Today's linux-next build (powerpc ppc64_defconfig) failed like this:
> > 
> > drivers/pci/hotplug/rpaphp_core.c:433: error: unknown field
> > 'get_max_bus_speed' specified in initializer
> > drivers/pci/hotplug/rpaphp_core.c:433: warning: excess elements in
> > struct initializer drivers/pci/hotplug/rpaphp_core.c:433: warning:
> > (near initialization for 'rpaphp_hotplug_slot_ops')
> > 
> > Caused by commit 7227d60c98ad0e1af49c717a62515d74002dd754 ("PCI:
> > Make current and maximum bus speeds part of the PCI core").
> > 
> > I have used the version of the pci tree from next-20100104 for
> > today.
> 
> Doh, sorry.  I don't have a handy powerpc environment around to test
> with. Can you try just deleting line 433?  (this should actually be
> the correct fix).

I just pushed that into my linux-next tree.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
