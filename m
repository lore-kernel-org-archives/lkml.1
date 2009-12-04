Return-Path: <linux-kernel-owner+w=401wt.eu-S1757553AbZLDXLC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553AbZLDXLC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 18:11:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753979AbZLDXLB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 18:11:01 -0500
Received: from outbound-mail-15.bluehost.com ([69.89.18.115]:43093 "HELO
	outbound-mail-15.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752537AbZLDXLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 18:11:01 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=G68MVR+jRzup96pYF4yDfqxfzemzedQaj9mK+VRlKR8Zz23oWUssrhuCsVjRZNjPA2USPWEWTOekJK3uZEPjq2CqAcNE5NUy/gqawLyi3t7SVvCUxE3/EIz2hmoFCKAh;
Date: Fri, 4 Dec 2009 15:10:14 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Mark McLoughlin <markmc@redhat.com>,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       Anthony Liguori <anthony@codemonkey.ws>, kvm@vger.kernel.org,
       Yan Vugenfirer <yvugenfi@redhat.com>
Subject: Re: [PATCH] virtio: set pci bus master enable bit
Message-ID: <20091204151014.22a39388@jbarnes-piketon>
In-Reply-To: <200912011034.02251.rusty@rustcorp.com.au>
References: <20091129155200.GA6667@redhat.com>
	<200912011034.02251.rusty@rustcorp.com.au>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Dec 2009 10:34:01 +1030
Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Mon, 30 Nov 2009 02:22:01 am Michael S. Tsirkin wrote:
> > As all virtio devices perform DMA, we
> > must enable bus mastering for them to be
> > spec compliant.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  drivers/virtio/virtio_pci.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/virtio/virtio_pci.c
> > b/drivers/virtio/virtio_pci.c index 28d9cf7..717bae1 100644
> > --- a/drivers/virtio/virtio_pci.c
> > +++ b/drivers/virtio/virtio_pci.c
> > @@ -648,6 +648,7 @@ static int __devinit virtio_pci_probe(struct
> > pci_dev *pci_dev, goto out_req_regions;
> >  
> >  	pci_set_drvdata(pci_dev, vp_dev);
> > +	pci_set_master(pci_dev);
> 
> I can believe this, but I have no idea if it's right.  I've applied
> it, and hope Jesse will comment if there's something wrong with it.

Nope, nothing wrong with that afaict.

-- 
Jesse Barnes, Intel Open Source Technology Center
