Return-Path: <linux-kernel-owner+w=401wt.eu-S1752463AbZIWWAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbZIWWAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 18:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbZIWWAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 18:00:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52252 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbZIWWAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 18:00:21 -0400
Date: Wed, 23 Sep 2009 18:00:22 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Tim Abbott <tabbott@ksplice.com>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       linux-modules@vger.org
Subject: Re: [PATCH 3/4] module: unexport each_symbol()
Message-ID: <20090923220022.GB30818@infradead.org>
References: <1253626718-18887-1-git-send-email-alan-jenkins@tuffmail.co.uk> <1253626718-18887-4-git-send-email-alan-jenkins@tuffmail.co.uk> <alpine.DEB.1.10.0909231112490.15822@dr-wily.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0909231112490.15822@dr-wily.mit.edu>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 01:29:43PM -0400, Tim Abbott wrote:
> While Ksplice is not in-tree yet, Ksplice is a user of each_symbol (and in 
> fact was the reason why each_symbol was originally exported).  Is it easy 
> to modify your patch series so that you don't have to remove each_symbol?

We don't keep symbols for out of tree junk around.

