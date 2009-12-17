Return-Path: <linux-kernel-owner+w=401wt.eu-S965324AbZLQTGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965324AbZLQTGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 14:06:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965291AbZLQTGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 14:06:12 -0500
Received: from outbound-mail-36.bluehost.com ([69.89.20.190]:57910 "HELO
	outbound-mail-36.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965293AbZLQTGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 14:06:10 -0500
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Dec 2009 14:06:10 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=q1XhQxC0cWSbEjuUVxbUsjPXXdvROGAy92LmiYu3baBDwsgc/oWK/4u4IclUIuf7su0rzgfJEOzFleIW8CBfB7GVmdiuKdcOPev65bAM5RxW8rtmjRp98T8IbOa5wsVL;
Date: Thu, 17 Dec 2009 10:59:00 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-pci@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Dexuan Cui <dexuan.cui@intel.com>
Subject: Re: linux-next: Tree for December 17 (pci/quirks)
Message-ID: <20091217105900.1d8b4f42@jbarnes-piketon>
In-Reply-To: <20091217095506.64f0a43f.randy.dunlap@oracle.com>
References: <20091217165840.e11fc719.sfr@canb.auug.org.au>
	<20091217095506.64f0a43f.randy.dunlap@oracle.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Dec 2009 09:55:06 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Thu, 17 Dec 2009 16:58:40 +1100 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > My usual call for calm: please do not put stuff destined for 2.6.34
> > into linux-next trees until after 2.6.33-rc1.
> > 
> > Changes since 20091216:
> 
> 
> When CONFIG_PCI_QUIRKS=n:
> 
> drivers/built-in.o: In function `pci_dev_reset':
> pci.c:(.text+0xdb0b): undefined reference to `pci_dev_reset_methods'
> pci.c:(.text+0xdb2b): undefined reference to `pci_dev_reset_methods'
> pci.c:(.text+0xdb85): undefined reference to `pci_dev_reset_methods'
> 
> 
> pci_dev_reset() calls (inlined) pci_dev_specific_reset(),
> which references pci_dev_reset_methods, which does not exist.

Dexuan, can you fix this up?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
