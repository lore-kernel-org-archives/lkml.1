Return-Path: <linux-kernel-owner+w=401wt.eu-S1752890AbZIXAPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbZIXAPW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 20:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbZIXAPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 20:15:18 -0400
Received: from ozlabs.org ([203.10.76.45]:59662 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbZIXAPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 20:15:17 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] module: unexport each_symbol()
Date: Thu, 24 Sep 2009 09:45:19 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: Tim Abbott <tabbott@ksplice.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       linux-modules@vger.org
References: <1253626718-18887-1-git-send-email-alan-jenkins@tuffmail.co.uk> <alpine.DEB.1.10.0909231112490.15822@dr-wily.mit.edu> <20090923220022.GB30818@infradead.org>
In-Reply-To: <20090923220022.GB30818@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909240945.19499.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Sep 2009 07:30:22 am Christoph Hellwig wrote:
> On Wed, Sep 23, 2009 at 01:29:43PM -0400, Tim Abbott wrote:
> > While Ksplice is not in-tree yet, Ksplice is a user of each_symbol (and in 
> > fact was the reason why each_symbol was originally exported).  Is it easy 
> > to modify your patch series so that you don't have to remove each_symbol?
> 
> We don't keep symbols for out of tree junk around.

I expected ksplice to go in earlier, actually.  I applied their export patch
to ease the transition.

I'd still like to see ksplice merged, but it's a big hunk of code.

Rusty.
