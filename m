Return-Path: <linux-kernel-owner+w=401wt.eu-S1754823AbXJWVUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbXJWVUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 17:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753447AbXJWVUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 17:20:35 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39895 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbXJWVUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 17:20:34 -0400
Date: Tue, 23 Oct 2007 22:20:32 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: thomas.mingarelli@hp.com, linux-kernel@vger.kernel.org,
       Wim Van Sebroeck <wim@iguana.be>
Subject: Re: [HP ProLiant WatchDog driver] hpwdt HP WatchDog Patch <resend>
Message-ID: <20071023212032.GA26597@infradead.org>
References: <20071022180711.5246.49013.sendpatchset@tmingo.cca.cpqcorp.net> <200710231431.15267.bjorn.helgaas@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710231431.15267.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 02:31:15PM -0600, Bjorn Helgaas wrote:
> The driver assumes only a single instance of the device.  But PCI being
> what it is, it's often possible to have multiple cards, so you might
> want some protection in case you trip over more than one.

Yes.  And even with that protection please move all the global variables
into some per-device structure.  That makes the code a lot more understandable
and future-proof in case multiple devices of this type may appear somewhere.

