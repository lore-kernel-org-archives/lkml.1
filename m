Return-Path: <linux-kernel-owner+w=401wt.eu-S932195AbXBSMc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195AbXBSMc4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 07:32:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932197AbXBSMc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 07:32:56 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:42212 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932195AbXBSMcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 07:32:55 -0500
Date: Mon, 19 Feb 2007 06:38:14 -0600
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 05/44 take 2] [UBI] internal common header
Message-ID: <20070219123813.GI1038@crusty.rchland.ibm.com>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain> <20070217165449.5845.18238.sendpatchset@localhost.localdomain> <20070219105445.GA16930@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070219105445.GA16930@infradead.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 19, 2007 at 10:54:45AM +0000, Christoph Hellwig wrote:
> On Sat, Feb 17, 2007 at 06:54:49PM +0200, Artem Bityutskiy wrote:
> > +#ifndef __UBI_UBI_H__
> > +#define __UBI_UBI_H__
> > +
> > +#include <linux/mtd/ubi.h>
> > +
> > +/* Version of this UBI implementation */
> > +#define UBI_VERSION 1
> 
> We shouldn't have versions for inkernel interfaces.

The versioning is part of the UBI block headers that are written to the medium.
It is not for in-kernel purposes, but required so things like bootloaders
can understand which version of UBI is on flash.

josh
