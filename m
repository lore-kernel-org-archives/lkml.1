Return-Path: <linux-kernel-owner+w=401wt.eu-S1759907AbXIXPus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759907AbXIXPus (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 11:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755340AbXIXPuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 11:50:40 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47822 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181AbXIXPuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 11:50:39 -0400
Subject: Re: Mask Issue?
From: David Woodhouse <dwmw2@infradead.org>
To: Mel Gorman <mel@skynet.ie>
Cc: Chris Holvenstot <cholvenstot@comcast.net>,
       kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20070924153920.GB32550@skynet.ie>
References: <1190242676.16474.6.camel@localhost>
	 <20070924153920.GB32550@skynet.ie>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 24 Sep 2007 16:50:36 +0100
Message-Id: <1190649036.2905.91.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8.dwmw2.1) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-24 at 16:39 +0100, Mel Gorman wrote:
> I noticed this in a -mm recently and never got around to kicking it
> properly because I suspected it was a compiler issue. What version
> of gcc and binutils are you using?
> 
> David Woodhouse added to cc in case this is a known problem.

The only reason for this is because once upon a time, the early FPGA
versions of the CAFÉ chip had the same PCI ident for all three
functions. The cluebat was applied; the chip was fixed long before
tape-out. We can just drop the whole class/mask thing, I suspect -- I
just want to boot it on and OLPC machine before I commit that.

-- 
dwmw2

