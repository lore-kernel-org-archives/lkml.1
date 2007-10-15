Return-Path: <linux-kernel-owner+w=401wt.eu-S1756231AbXJOIwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231AbXJOIwd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 04:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbXJOIwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 04:52:23 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52738 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbXJOIwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 04:52:22 -0400
Date: Mon, 15 Oct 2007 09:52:10 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: Rob Landley <rob@landley.net>,
       James Bottomley <James.Bottomley@steeleye.com>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Nick Piggin <piggin@cyberone.com.au>
Subject: Re: What still uses the block layer?
Message-ID: <20071015085210.GA23589@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Greg KH <greg@kroah.com>, Rob Landley <rob@landley.net>,
	James Bottomley <James.Bottomley@steeleye.com>,
	Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>,
	Suparna Bhattacharya <suparna@in.ibm.com>,
	Nick Piggin <piggin@cyberone.com.au>
References: <200710112011.22000.rob@landley.net> <20071013220539.GD29934@parisc-linux.org> <1192400672.3351.56.camel@localhost.localdomain> <200710141845.44750.rob@landley.net> <20071015060015.GB32268@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071015060015.GB32268@kroah.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 14, 2007 at 11:00:15PM -0700, Greg KH wrote:
> If you hate USB storage devices using scsi, please use the ub driver,
> that is what it was written for.

The ub driver is a really dumb piece of shit.  It only drivers usb storage
devices using a scsi protocol set, and duplicates the scsi stack in a very
suboptimal way.

