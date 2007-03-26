Return-Path: <linux-kernel-owner+w=401wt.eu-S1753767AbXCZUDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767AbXCZUDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 16:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753769AbXCZUDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 16:03:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49050 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763AbXCZUDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 16:03:07 -0400
Date: Mon, 26 Mar 2007 21:02:57 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>, linux-scsi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: some PCMCIA SCSI drivers can be built *only* as modules
Message-ID: <20070326200257.GA28622@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	"Robert P. J. Day" <rpjday@mindspring.com>,
	linux-scsi@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0703250916090.22484@CPE00045a9c397f-CM001225dbafb6> <4607CA5A.4040906@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4607CA5A.4040906@s5r6.in-berlin.de>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >   it would seem to make no sense that the "depends on" clause for this
> > option includes "m", forcing this (and all other four entries in that
> > Kconfig file, by the way) to be built as modules, while the help text
> > for all five entries suggests you can select "y".

In the old days pcmcia drivers had to be modular because pcmcia required
a lot of userspace setup.  It's not needed anymore these days and the
dependencies can go.

