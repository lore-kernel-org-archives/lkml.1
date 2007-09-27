Return-Path: <linux-kernel-owner+w=401wt.eu-S1757476AbXI0Oea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476AbXI0Oea (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 10:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756030AbXI0OeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 10:34:17 -0400
Received: from brick.kernel.dk ([87.55.233.238]:5146 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755971AbXI0OeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 10:34:16 -0400
Date: Thu, 27 Sep 2007 16:35:48 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arjan van de Ven <arjan@infradead.org>, akpm@osdl.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs: Correct SuS compliance for open of large file
	without options
Message-ID: <20070927143548.GT5243@kernel.dk>
References: <20070927142919.10b62f9b@the-village.bc.nu> <20070927070118.2bd4792e@laptopd505.fenrus.org> <20070927151921.29b19abb@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927151921.29b19abb@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27 2007, Alan Cox wrote:
> On Thu, 27 Sep 2007 07:01:18 -0700
> Arjan van de Ven <arjan@infradead.org> wrote:
> 
> > On Thu, 27 Sep 2007 14:29:19 +0100
> > Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > 
> > > The early LFS work that Linux uses favours EFBIG in various places.
> > > SuSv3 specifically uses EOVERFLOW for this as noted by Michael (Bug
> > > 7253)
> > isn't this an ABI change?
> 
> Its a change of a specific error return from the wrong error to the right
> one, nothing more. Fixing the returned error gives us correct behaviour
> according to the standards and other systems.

It may still break applications. Waving some standard at them if they
complain is unlikely to impress them.

-- 
Jens Axboe

