Return-Path: <linux-kernel-owner+w=401wt.eu-S1753629AbXFWRws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbXFWRws (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 13:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755871AbXFWRwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 13:52:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:28896 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbXFWRwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 13:52:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=Elr68wzNsxP/1DHilFEaHMkqNlY1qje6T8maYNdMz1MPIFuFeuRLXSd1lIyV7ktWgW4qlk6Sp2Txmc8aQaemyzUrIUJb+qsswtD/lGV+4WWyGUBSNar/F0lOCy88xNNfX/sw5KtQs9BSVBuRJoefXf6+KOHmcukWGRgPUBUnXjQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Carlo Wood <carlo@alinoe.com>
Subject: Re: SATA RAID5 speed drop of 100 MB/s
Date: Sat, 23 Jun 2007 19:30:57 +0200
User-Agent: KMail/1.9.6
Cc: Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       Manoj Kasichainula <manoj@io.com>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
References: <20070620224847.GA5488@alinoe.com> <467CC5C5.6040201@garzik.org> <20070623125316.GB26672@alinoe.com>
In-Reply-To: <20070623125316.GB26672@alinoe.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706231930.57688.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Saturday 23 June 2007, Carlo Wood wrote:

> PS I'd like to do extensive testing with Bonnie++ to tune everything
> there is to tune. But bonnie likes to write/read files TWICE the amount
> of RAM I have. It therefore takes a LOT of time to run one test. Do you
> happen to know how I can limit the amount of RAM that the linux kernel
> sees to, say 500 MB? That should be enough to run in Single User mode
> but allow me to run the tests MUCH faster. (I have dual channel, four
> DIMM's of 1 GB each -- 2 GB per Core 2 die. Hopefully the fact that
> I have dual channel isn't going to be a problem when limiting the ram
> that the kernel sees.)

"mem=" kernel parameter limits amount of memory seen by kernel
(more info in Documentation/kernel-parameters.txt)

You can also limit amount of RAM detected by bonnie++ by using -r parameter
but please remember that this will make bonnie++ benchmark combined kernel
I/O buffering + filesystem + hard disk performance instead of just filesystem
+ hard disk performance (as it can happen that some / all data won't ever
hit the disk).

Bart
