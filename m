Return-Path: <linux-kernel-owner+w=401wt.eu-S1759746AbZFQR3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759746AbZFQR3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 13:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759643AbZFQR3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 13:29:05 -0400
Received: from outbound-mail-311.bluehost.com ([67.222.54.4]:37189 "HELO
	outbound-mail-311.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759627AbZFQR3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 13:29:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=d/leBxQdoxDT8HQIi5sNP5h1asS7dqhByVhDuRw6vTMJ4FTw9HP1U0alOv2lkFLyYvn1knQNgMJAbbMXGPNfFJ+9InAqmgHEEPKXYSKCAD1+uxfxu71omZCJPcWVfxa2;
Date: Wed, 17 Jun 2009 10:29:01 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Alex Chiang <achiang@hp.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: linux-next: Tree for June 17 (pci/slot)
Message-ID: <20090617102901.6e39aac2@jbarnes-g45>
In-Reply-To: <20090617163604.GT19977@parisc-linux.org>
References: <20090617155354.075c60ae.sfr@canb.auug.org.au>
	<4A39194B.2060200@oracle.com>
	<20090617163604.GT19977@parisc-linux.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jun 2009 10:36:04 -0600
Matthew Wilcox <matthew@wil.cx> wrote:

> On Wed, Jun 17, 2009 at 09:26:51AM -0700, Randy Dunlap wrote:
> > Stephen Rothwell wrote:
> > > Hi all,
> > > 
> > > Changes since 20090616:
> > 
> > 
> > When CONFIG_SYSFS=n:
> > 
> > drivers/pci/slot.c:327: error: 'module_kset' undeclared (first use
> > in this function)
> 
> Is there any point to pci_slot existing without CONFIG_SYSFS?
> I don't see how you can interact with it in any meaningful way.
> Perhaps CONFIG_PCI_SLOT should depend on CONFIG_SYSFS?

I've got a code fix queued up, but maybe a Kconfig dependency is the
way to go...

-- 
Jesse Barnes, Intel Open Source Technology Center
