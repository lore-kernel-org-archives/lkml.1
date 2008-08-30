Return-Path: <linux-kernel-owner+w=401wt.eu-S1756777AbYH3Gtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbYH3Gtw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 02:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbYH3Gtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 02:49:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:50962 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbYH3Gtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 02:49:41 -0400
Subject: Re: [patch 1/3] crypto: Add a zlib crypto module
From: David Woodhouse <dwmw2@infradead.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       linux-crypto@vger.kernel.org, squashfs-devel@lists.sourceforge.net,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080830062315.GA18441@gondor.apana.org.au>
References: <20080829134158.108976037@vixen.sonytel.be>
	 <20080829134418.874948211@vixen.sonytel.be>
	 <20080830062315.GA18441@gondor.apana.org.au>
Content-Type: text/plain
Date: Sat, 30 Aug 2008 07:39:57 +0100
Message-Id: <1220078397.7107.433.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-08-30 at 16:23 +1000, Herbert Xu wrote:
> On Fri, Aug 29, 2008 at 01:41:59PM +0000, Geert Uytterhoeven wrote:
> > From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> > 
> > Add a (de)compression module for the "zlib" format using the crypto API.
> 
> I think we can safely conclude that our current compression
> interface sucks for what you're trying to achieve :)

The main thing that's missing for JFFS2 is 
 "Compress as much of this as you can into X bytes"

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



