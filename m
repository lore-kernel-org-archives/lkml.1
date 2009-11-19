Return-Path: <linux-kernel-owner+w=401wt.eu-S1756834AbZKSVt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834AbZKSVt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 16:49:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755880AbZKSVtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 16:49:55 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:45147 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614AbZKSVty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 16:49:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=CdnO/Wdx+fcrWbl0k7dQhkfkpUNlGVrT8PS/6k+GplG3YeQWCw1KQFgES+i4kRG70j
         3LQUoY83o7fmd6SQJx4gFxs5pyBHs8bT7BPZ5p88qE/QxpmbdikVuCEGKV3irj6wSEzu
         6rRjUNMZBm4JFjdLYs1EPXGh0a1Cpgov7+8yM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 4/5] pata: Update experimental tags
Date: Thu, 19 Nov 2009 22:49:16 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Alan Cox <alan@linux.intel.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <20091117144450.15430.83450.stgit@localhost.localdomain> <200911182056.16517.bzolnier@gmail.com> <4B05BADF.1010205@garzik.org>
In-Reply-To: <4B05BADF.1010205@garzik.org>
MIME-Version: 1.0
Message-Id: <200911192249.16860.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 November 2009 22:38:39 Jeff Garzik wrote:
> On 11/18/2009 02:56 PM, Bartlomiej Zolnierkiewicz wrote:
> > On Wednesday 18 November 2009 20:07:07 Bartlomiej Zolnierkiewicz wrote:
> >> On Wednesday 18 November 2009 19:41:25 Alan Cox wrote:
> >>>> Maybe they are 'stable' but when it comes to features they are behind hpt366
> >>>> (i.e. they lack PCI PM), which is also much cleaner than your drivers, easier
> >>>> to understand and much smaller..
> >>>
> >>> 37x and 3xn lack PCI PM.  Added to the TODO list.
> >>>
> >>> The smaller size is a bit questionable given its mostly comments, and
> >>> three drivers versus one.
> >>
> >> I wonder what you find 'questionable' in the numbers given..
> >
> > BTW we can immediately reclaim 300 LOC by simply merging drivers back..
> 
> Merging drivers is a big pain for distributions and end users, even with 
> the new module_alias facility.

Could please explain in more detail 'a big pain' part?

> Absent stronger justification, libata remains with separate drivers, 
> even if that means some code duplication.

I can always hold my own tree with such changes if needed.

-- 
Bartlomiej Zolnierkiewicz
