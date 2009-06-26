Return-Path: <linux-kernel-owner+w=401wt.eu-S1761635AbZFZThq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761635AbZFZThq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 15:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761260AbZFZThi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 15:37:38 -0400
Received: from outbound-mail-26.bluehost.com ([69.89.17.191]:60751 "HELO
	outbound-mail-26.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758855AbZFZThh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 15:37:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=dFE8XpyKocAtXSASMrj/zqwnRKxEFb1Cyos1whTsW9wHuW0ldr6zrUkfWPBJ7V4yKVTtc1SL2MHdVp+rjhGa3B7yDPFOWCcAdH4v4k2XZYC35hcR9mDjH+PAraCNxL0t;
Date: Fri, 26 Jun 2009 12:37:36 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio_blk: add missing __dev{init,exit} markings
Message-ID: <20090626123736.594969c8@jbarnes-g45>
In-Reply-To: <200905200010.51786.rusty@rustcorp.com.au>
References: <1242632349-15894-1-git-send-email-vapier@gentoo.org>
	<200905200010.51786.rusty@rustcorp.com.au>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.17.2; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 May 2009 00:10:51 +0930
Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Mon, 18 May 2009 05:09:09 pm Mike Frysinger wrote:
> > -static int virtblk_probe(struct virtio_device *vdev)
> > +static int __devinit virtblk_probe(struct virtio_device *vdev)
> 
> This makes sense, I think, but then it implies that
> virtio_dev_probe() should also be __devinit, right?
> 
> And I look at pci_bus_probe(), and it's not __devinit.
> 
> Is the PCI code just slack?

I wouldn't be surprised if some annotations were missing or incorrect
given the churn in hotplug lately, but I can't find that particular
symbol...

-- 
Jesse Barnes, Intel Open Source Technology Center
