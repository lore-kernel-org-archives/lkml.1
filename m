Return-Path: <linux-kernel-owner+w=401wt.eu-S1753503AbYACM0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbYACM0Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 07:26:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750781AbYACM0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 07:26:14 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46681 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbYACM0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 07:26:13 -0500
Date: Thu, 3 Jan 2008 12:26:10 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Andy Whitcroft <andyw@uk.ibm.com>
Cc: Christer Weinigel <christer@weinigel.se>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] teach checkpatch.pl about list_for_each
Message-ID: <20080103122610.GA18255@infradead.org>
References: <20071202130335.690a8daf@cw05lap> <20080103111058.GE10861@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080103111058.GE10861@shadowen.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2008 at 11:10:58AM +0000, Andy Whitcroft wrote:
> We have had some stabs at changing this, but no consensus was reached on
> whether it was a "for" or a "function".  My memory is of there being
> slightly more "without a space" tenders than the other and so it has not
> been changed.  This thread also seems so far to have not really
> generated a concensus.  So I would tend to leave things as they are.  
> 
> A third option might be to accept either on *for_each* constructs.
> That might tend to lead to divergance.  Difficult.  However, also see my
> later comments on "style guide".

Pretty much all core code uses list_for_each_entry( so new code should
follow that example.

