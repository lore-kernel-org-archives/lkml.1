Return-Path: <linux-kernel-owner+w=401wt.eu-S1751203AbYD2JjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751203AbYD2JjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 05:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbYD2JjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 05:39:09 -0400
Received: from gir.skynet.ie ([193.1.99.77]:47386 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbYD2JjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 05:39:08 -0400
Date: Tue, 29 Apr 2008 10:39:05 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, bzolnier@gmail.com
Subject: Re: 2.6.25-mm1: Failing to probe IDE interface
Message-ID: <20080429093904.GA4503@csn.ul.ie>
References: <20080417160331.b4729f0c.akpm@linux-foundation.org> <20080428164235.GA29229@csn.ul.ie> <20080428095924.3b7dfb96.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080428095924.3b7dfb96.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (28/04/08 09:59), Andrew Morton didst pronounce:
> On Mon, 28 Apr 2008 17:42:36 +0100 Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > An old T21 is failing to boot and the relevant message appears to be
> > 
> > [    1.929536] Probing IDE interface ide0...
> > [   36.939317] ide0: Wait for ready failed before probe !
> > [   37.502676] ide0: DISABLED, NO IRQ
> > [   37.506356] ide0: failed to initialize IDE interface
> > 
> > The owner of ide-mm-ide-add-struct-ide_io_ports-take-2.patch with the
> > "DISABLED, NO IRQ" message is cc'd. I've attached the config, full boot log
> > and lspci -v for the machine in question. I'll start reverting some of the
> > these patches to see if ide-mm-ide-add-struct-ide_io_ports-take-2.patch
> > is really the culprit.
> 
> ide-mm-ide-add-struct-ide_io_ports-take-2.patch is now in mainline so a
> quicky confirmation would be to test Linus's tree.
> 

2.6.25 and latest git are both booting fine.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
