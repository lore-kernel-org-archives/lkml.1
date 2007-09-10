Return-Path: <linux-kernel-owner+w=401wt.eu-S1760876AbXIJUnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760876AbXIJUnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 16:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759829AbXIJUnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 16:43:11 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:38230 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758007AbXIJUnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 16:43:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PwgsDbHj4lZ1Xch/SFn4Lf/Bw5nfmD8ZQ/rQdHhhPlQFnnzbczLzvk8r9OCJ6MOG9Veb9nxBhBLnUhQDUjkj+ueSXRCZ3dHj8jIz2KjHxq/nHIyPFQvn0UuDcPqwVS6bcg9SPuuiHNg9GWQaYknbdzRpBA9+/hernWpc2q5JFLY=
Message-ID: <64bb37e0709101343t2a621239pfc3545263e0b7674@mail.gmail.com>
Date: Mon, 10 Sep 2007 22:43:07 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "FUJITA Tomonori" <tomof@acm.org>
Subject: Re: 2.6.23-rc4-mm1
Cc: akpm@linux-foundation.org, apw@shadowen.org, linux-kernel@vger.kernel.org,
       mel@csn.ul.ie, jens.axboe@oracle.com, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
In-Reply-To: <20070910045503O.tomof@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070910111926.9c942358.akpm@linux-foundation.org>
	 <64bb37e0709101159v47f586aby7f078ef1db5cbc39@mail.gmail.com>
	 <20070910122038.1f1bb006.akpm@linux-foundation.org>
	 <20070910045503O.tomof@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/10/07, FUJITA Tomonori <tomof@acm.org> wrote:
> On Mon, 10 Sep 2007 12:20:38 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
>
> > On Mon, 10 Sep 2007 20:59:49 +0200 "Torsten Kaiser" <just.for.lkml@googlemail.com> wrote:
> > > The system boots, reads the partition tables, starts the RAID and then
> > > kicks one drive out because of errors.
> >
> > Andy is using qla1280.  You're using sata.  So it's probably a different
> > bug, with the same symptoms.
>
> This might be a sg chaining bug too (probabaly sg chaining libata
> patch).
>
> Can you try the following patch that I've just sent:
>
> http://lkml.org/lkml/2007/9/10/251
>
> The patch also disables chaining sg list for libata.
>
With this patch 2.6.23-rc4-mm1 works for me.
Mainline 2.6.23-rc5-git1 works also without needing any patches.

Torsten
