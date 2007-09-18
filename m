Return-Path: <linux-kernel-owner+w=401wt.eu-S1756063AbXIRJQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063AbXIRJQH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 05:16:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753906AbXIRJPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 05:15:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629AbXIRJPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 05:15:54 -0400
Date: Tue, 18 Sep 2007 05:14:00 -0400
From: Alan Cox <alan@redhat.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Mikael Pettersson <mikpe@it.uu.se>, Jeff Norden <jeff@math.tntech.edu>,
       alan@redhat.com, linux-kernel@vger.kernel.org,
       Albert CC Lee <albertcc@tw.ibm.com>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: [PATCH 1/1] pata_it821x: fix lost interrupt with atapi devices
Message-ID: <20070918091400.GC13425@devserv.devel.redhat.com>
References: <200709041607.l84G7KsT032647@norden.math.tntech.edu> <18141.42848.537873.349518@alkaid.it.uu.se> <20070906013929.1621849d@the-village.bc.nu> <46EE09D3.9010201@gmail.com> <46EE5033.7060708@garzik.org> <46EE68F9.9050707@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46EE68F9.9050707@gmail.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2007 at 01:46:01PM +0200, Tejun Heo wrote:
> failures and would really like to know what's broken.  The reason can be
> one of the following two.
> 
> 1. libata itself isn't doing anything wrong but using SCSI for mid and
> high level drivers are causing problems as more types of commands are used.
> 
> 2. Mode programming for MWDMA is broken.  This doesn't seem too likely
> as we're seeing MWDMA failures across different low level drivers but is
> still a possibility.

3 and 4

3. Libata is wrong (it is in places)

4. Old IDE uses DMA much less for ATAPI especially
