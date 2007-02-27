Return-Path: <linux-kernel-owner+w=401wt.eu-S1751625AbXB0ORS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625AbXB0ORS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 09:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751653AbXB0ORS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 09:17:18 -0500
Received: from rrcs-24-153-217-226.sw.biz.rr.com ([24.153.217.226]:55834 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751624AbXB0ORR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 09:17:17 -0500
Subject: Re: [PATCH 7/7] cxgb3 - Add SW LRO support
From: Steve Wise <swise@opengridcomputing.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: divy@chelsio.com, jeff@garzik.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070226051304.GA13626@infradead.org>
References: <20070225004423.20903.17036.stgit@localhost.localdomain>
	 <20070226051304.GA13626@infradead.org>
Content-Type: text/plain
Date: Tue, 27 Feb 2007 08:17:15 -0600
Message-Id: <1172585835.11870.13.camel@stevo-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-26 at 05:13 +0000, Christoph Hellwig wrote:
> On Sat, Feb 24, 2007 at 04:44:23PM -0800, divy@chelsio.com wrote:
> > From: Divy Le Ray <divy@chelsio.com>
> > 
> > Add all-in-sw lro support.
> 
> Doing this in a LLDD doesn't sound like a good idea.  Have you
> tried doing this in the core networking code instead?

It looks like both Netxen and Neterion drivers already have this.  So I
think for now the LLDD implements LRO.  The stack supports it by virtue
of allowing fragmented skbs that are bigger than the MTU.

Other drivers implementing LRO:

drivers/net/s2io.c
drivers/net/netxen/

Steve.

