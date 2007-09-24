Return-Path: <linux-kernel-owner+w=401wt.eu-S1755974AbXIXHFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974AbXIXHFh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 03:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbXIXHF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 03:05:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44474 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbXIXHF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 03:05:29 -0400
Date: Mon, 24 Sep 2007 08:05:28 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Hector Martin <hector@marcansoft.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Coding FATX support for 2.6
Message-ID: <20070924070528.GA6938@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Hector Martin <hector@marcansoft.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <46F6D1C3.2070208@marcansoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F6D1C3.2070208@marcansoft.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 23, 2007 at 04:51:15PM -0400, Hector Martin wrote:
> I see several options for implementing this:
> - Add support to the standard FAT driver. This should probably be made a
> configurable suboption.
> - Add support that piggybacks onto the standard FAT driver, but
> otherwise doesn't touch it. I don't know how feasible this is.
> - Modify the FAT driver to allow the basic changes needed to support
> FATX, then piggyback it for the actual implementation. See above.
> - Fork the FAT driver and make it into a FATX driver.
> - Start from scratch.
> 
> I'm unsure about what the best option would be. Obviously changes to FAT
> should be made with care, as we don't want to cause a regression.
> However, much of the code (allocation strategies, FAT handling, etc)
> should be the same or very similar, so it seems stupid to start from
> scratch.

I'd start with modifying the existing FAT driver.  Once you have working
code you can look at the amount of changes and decided if you want to
add support to the existing driver or fork it.  If you think you can't
just judge it by yourself send your prototype to lkml or -fsdevel for
an rfc so we can look over it and guide you a little on how to do it.
