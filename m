Return-Path: <linux-kernel-owner+w=401wt.eu-S1752122AbZH1Qzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122AbZH1Qzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 12:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbZH1Qzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 12:55:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60742 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbZH1Qzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 12:55:31 -0400
Date: Fri, 28 Aug 2009 12:55:26 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Nikanth Karthikesan <knikanth@suse.de>, xfs@oss.sgi.com,
       linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Kernel 2.6.30.4 loop(..?) regression (& with/2.6.31-rc6)
Message-ID: <20090828165526.GA6133@infradead.org>
References: <20090822205502.GA18904@infradead.org> <alpine.DEB.2.00.0908221659030.23463@p34.internal.lan> <20090823224504.GA19942@infradead.org> <alpine.DEB.2.00.0908240704130.9427@p34.internal.lan> <alpine.DEB.2.00.0908260949550.9396@p34.internal.lan> <20090826180234.GC14019@infradead.org> <alpine.DEB.2.00.0908261717001.1594@p34.internal.lan> <20090826212732.GA18124@infradead.org> <alpine.DEB.2.00.0908261728580.1594@p34.internal.lan> <alpine.DEB.2.00.0908280720220.30806@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908280720220.30806@p34.internal.lan>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 28, 2009 at 07:23:11AM -0400, Justin Piszcz wrote:
> If both '-o nobarrier' and the patch solves the issue, what is the next  
> action that should be taken?  Update the documentation to always use
> -o nobarrier for cryptoloop? Or get the patch reverted in mainline?

We'll have to figure out why it causes those problems and how fix them.
-o nobarrier on a loop device is extremly unsafe as you will possible
lose large amounts of log updates in case of a crash.

