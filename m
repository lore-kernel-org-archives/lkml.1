Return-Path: <linux-kernel-owner+w=401wt.eu-S1756989AbXEQRCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989AbXEQRCm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 13:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755383AbXEQRCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 13:02:33 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:33543 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146AbXEQRCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 13:02:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=W/o9x+gxlpK2FheR13BemOIFz1OFgpgfN2gAlh63y8jEPL5d9pR0YRu6BsQFgwWy29vkGwgQmlvXgzjT5SadMMTlD4Pckaz7FQYWt0gptrsFjJsPLj/sBNhLliUYkb+xGNH5uS2LUfG0INVb+x8I6QgT94Rkv+Iv+hzHJRNE588=
Message-ID: <a781481a0705171002m61bdb9e9ka53c38cbe698265e@mail.gmail.com>
Date: Thu, 17 May 2007 22:32:30 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "James Bottomley" <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] SCSI: Let users disable SCSI_WAIT_SCAN to be built
Cc: "Stefan Richter" <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org,
       "Simon Arlott" <simon@fire.lp0.eu>, "Dave Jones" <davej@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       kernel-packagers@vger.kernel.org, "Matthew Wilcox" <matthew@wil.cx>
In-Reply-To: <1179410407.3785.16.camel@mulgrave.il.steeleye.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1179073116.3723.45.camel@mulgrave.il.steeleye.com>
	 <1179153096.3703.23.camel@mulgrave.il.steeleye.com>
	 <a781481a0705141741u4c2f442dk76c68f757cadc38d@mail.gmail.com>
	 <17841.simon.1179228389@5ec7c279.invalid>
	 <20070515120228.GI10562@parisc-linux.org>
	 <4649E03A.1090004@simon.arlott.org.uk>
	 <20070515172905.GJ10562@parisc-linux.org>
	 <tkrat.99c0f1a1898aa67f@s5r6.in-berlin.de>
	 <464B1886.1060502@s5r6.in-berlin.de>
	 <1179410407.3785.16.camel@mulgrave.il.steeleye.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/17/07, James Bottomley <James.Bottomley@steeleye.com> wrote:
> [...]
> Please don't bother ... I really want a more considered way of fixing
> this.  If everyone decides the best way is exposing this to the user,
> then this is the way to do it ... however, I still don't consider this
> argument made out yet.

Neither do I, considering that the user can switch async scanning on
at any later time with the scan=async module option. The absence
of the async scan wait module will only screw things up for him later.

But then I don't consider an argument made out yet for doing this
via a separate module in the first place. scsi_wait_scan just does
_not_ want/deserve/need to be a module.

Of course, whining is useless, and discussions on lkml tend to be
most constructive / progressive only over code, so I'll try and see
if I can learn enough of the code in there to fix a patch to do the
async scan waiting thing using some other mechanism; this
module thing seems just horribly wrong/unnecessary.
