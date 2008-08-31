Return-Path: <linux-kernel-owner+w=401wt.eu-S1759324AbYHaOf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759324AbYHaOf3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 10:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757487AbYHaOfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 10:35:16 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:4521 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757270AbYHaOfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 10:35:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=qRSHg15p91sYgH7aSoFykb7fSTQpxi8qGxstV1IxIMt4e01GtejHZ/APQiQaCckcqb
         h3fXgO7HwCGc4d2Jebt6x2z/lOHLATW2eeeaoENJnglA8PwafCl5ez8NZkycDLPtJYSM
         47hL3SkATwQBzpuykrT+aIubUFf5KsF4B1/GI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Tejun Heo <tj@kernel.org>
Subject: Re: linux-next: Tree for August 27
Date: Sun, 31 Aug 2008 15:38:38 +0200
User-Agent: KMail/1.9.9
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       dm-devel@redhat.com
References: <20080827183453.eb651f50.sfr@canb.auug.org.au> <200808292123.07246.bzolnier@gmail.com> <48B90E81.5060905@kernel.org>
In-Reply-To: <48B90E81.5060905@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808311538.38918.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 30 August 2008, Tejun Heo wrote:

[...]

> > Actually it seems that CONFIG_DEBUG_BLOCK_EXT_DEVT introduction (which I
> > think is a nice step forward) is a good oportunity to put the deprecation
> > of the default root device further, i.e. it may be worth to hook the
> > default root device check and/or CONFIG_DEBUG_BLOCK_EXT_DEVT one into
> > mount_block_root().
> 
> Maybe we can add a warning there if BLOCK_EXT_DEVT is enabled or do
> you have something else on mind?

Yes, this is would be nice, having warning on using the default root
device (instead of "root=") would be even nicer.

Thanks,
Bart
