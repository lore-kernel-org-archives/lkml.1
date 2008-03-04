Return-Path: <linux-kernel-owner+w=401wt.eu-S1761370AbYCDRy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761370AbYCDRy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 12:54:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756255AbYCDRyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 12:54:46 -0500
Received: from gv-out-0910.google.com ([216.239.58.188]:47940 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174AbYCDRyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 12:54:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=qvlevgvhOk6TP3Qlg5X7j98yuHbA9PEVzN7QGmYQfU55frx2m959nAHSDaGIqbttRT2ozCGn0qthLaQJe4x+xJbvGQ2Nmktar6aEo8OoxIRplawXdj7tkKNVuhrqiCeTqz9BF6xKhMTEjUnpujaEH3EzBiDVUZwiiBFH0JMyjDQ=
Message-ID: <e9c3a7c20803040954i2a8877a2v61079f765ea21fa8@mail.gmail.com>
Date: Tue, 4 Mar 2008 10:54:41 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Stephen Rothwell" <sfr@canb.auug.org.au>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: linux-next: Tree for March 4
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080304223947.375be10b.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080304223947.375be10b.sfr@canb.auug.org.au>
X-Google-Sender-Auth: d7bd321f8cafaa12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 4, 2008 at 4:39 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>  We are up to 40 trees, more are welcome (even if they are currently
>  empty).  The influx of new trees has been underwhelming.  Thanks to those
>  who have contributed, and to those who haven't, please do.
>

Hello Stephen, Andrew,

I have recently moved the async_tx git tree to kernel.org.

For linux-next please add:

    master.kernel.org:/pub/scm/linux/kernel/git/djbw/async_tx.git next

For -mm please replace the 'git-md-accel' url with the following, it
should also be renamed to 'git-async-tx' as anything that impacts MD
will go through Neil.

    master.kernel.org:/pub/scm/linux/kernel/git/djbw/async_tx.git upstream

Currently both trees contain the following:
Dan Williams (7):
      fsldma: do not cleanup descriptors in hardirq context
      dmaengine: fix sparse warning
      ioat: fix 'ack' handling, driver must ensure that 'ack' is zero
      async_tx: checkpatch says s/__FUNCTION__/__func__/g
      async_tx: fix multiple dependency submission
      async_tx: kill ->device_dependency_added
      iop-adma: remove the workaround for missed interrupts on iop3xx

Zhang Wei (1):
      dmaengine: add driver for Freescale MPC85xx DMA controller

Regards,
Dan
