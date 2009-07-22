Return-Path: <linux-kernel-owner+w=401wt.eu-S1754223AbZGVWQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbZGVWQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 18:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbZGVWQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 18:16:47 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54820 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753283AbZGVWQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 18:16:46 -0400
Date: Wed, 22 Jul 2009 23:17:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dave Jones <davej@redhat.com>
Cc: Pavel Vasilyev <pavel@pavlinux.ru>, linux-kernel@vger.kernel.org
Subject: Re: GART_IOMMU without AGP
Message-ID: <20090722231738.21de4deb@lxorguk.ukuu.org.uk>
In-Reply-To: <20090722213746.GA20241@redhat.com>
References: <200907221926.50397.pavel@pavlinux.ru>
	<20090722213746.GA20241@redhat.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jul 2009 17:37:46 -0400
Dave Jones <davej@redhat.com> wrote:

> On Wed, Jul 22, 2009 at 07:26:49PM +0400, Pavel Vasilyev wrote:
>  > In the kernel configuration, if I choose x86_64 and PCI, then choose the item
>  > "Garth IOMMU support", which, in turn, chooses not to switch off, support for
>  > AGP. But many IOMMU system does not have AGP bus.
>  
> The lack of AGP slots doesn't mean a lack of AGP bus.
> It's part of the K8 on-CPU northbridge.

And the user is selecting CONFIG_AGP to select AGP devices rather than to
demonstrate their deep guru grade knowledge of K8 northbridges. Not only
that but CONFIG_AGP controls the display of AGP video card options so it
is a selection for offered devices not really an internal detail.

So I think Pavel is right here.

