Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836AbYDISJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbYDISJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 14:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755937AbYDISJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 14:09:10 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:22997 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266AbYDISJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 14:09:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=pk9QScG79PmINMHZ8ilMxA/F1uKsDn87KbAlcgswt2bz7o38vuoIz+OpFmY/qJ1c2T58jm3eVpzfdeGOJB7WjvUAmjUyQBvBa1HdZx3UVVpmAPbZR6LzBhSNUwer0YUdyofDwEmRPWTLah0TDWF0CHorj7vUqPMIT/yHvGsdltg=
Date: Wed, 9 Apr 2008 20:13:14 +0200
From: Richard Zidlicky <rz@linux-m68k.org>
To: Michael Schmitz <schmitz@zirkon.biophys.uni-duesseldorf.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-ide@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Michael Schmitz <schmitz@debian.org>
Subject: Re: [PATCH 5/5] falconide/q40ide: add ->atapi_*put_bytes and
	->ata_*put_data methods
Message-ID: <20080409181314.GA999@linux-m68k.org>
References: <200803301714.04527.bzolnier@gmail.com> <200803302134.42569.bzolnier@gmail.com> <Pine.LNX.4.64.0803310750230.6871@anakin> <200804072113.42441.bzolnier@gmail.com> <20080408094029.GA1005@linux-m68k.org> <alpine.DEB.1.00.0804090337110.19638@zirkon.biophys.uni-duesseldorf.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0804090337110.19638@zirkon.biophys.uni-duesseldorf.de>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2008 at 03:40:34AM +0200, Michael Schmitz wrote:

> > However, not only FS data is byteswapped, complete disk including partition
> > table and everything else is. Will "rq->cmd_type == REQ_TYPE_FS" also catch
> > all these cases?
> 
>  IIRC only identify data (and perhaps ATAPI data) need to be byteswapped 
>  twice (or not at all), so REQ_TYPE_FS should catch all other cases.

my main worry is whether REQ_TYPE_FS is set even when using raw disk access,
eg reading partition table or raw partitions.

The partition table initialisation is one of the reasons why using dmapper
would be a major pain btw.

>  (Good catch about ATAPI there, BTW - I never thought about that, and ISTR 
>  that IDE CD-ROMs never worked in Linux. That would be the reason why..)

IDE CDROM works perfectly on the Q40?

Richard
