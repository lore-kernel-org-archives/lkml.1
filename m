Return-Path: <linux-kernel-owner+w=401wt.eu-S1763792AbXGFJ6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763792AbXGFJ6q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 05:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759416AbXGFJ6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 05:58:37 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:51208 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763631AbXGFJ6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 05:58:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=SviDUn4DToFltiwb7r0YO5IHDpPd8DcAAWu9oXWcSG1DSpVnsKT9kcaYEDhui3hNhuU5fT22O1r1A2pOBihphy094RDQMiCpGwCXg14GrlxqY9PBLaJSWTRGQT+4wwYIegJEygB9OepW8JRNgpFO0rw4P+b0QBTYBmAAmtpnpBI=
From: Suren Karapetyan <surenkarapetyan@gmail.com>
To: Christoph Pleger <Christoph.Pleger@cs.uni-dortmund.de>
Subject: Re: PATA-disk named sda
Date: Fri, 6 Jul 2007 14:58:06 +0500
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <20070706102132.14fbc600.Christoph.Pleger@cs.uni-dortmund.de> <200707061413.53182.surenkarapetyan@gmail.com> <20070706113618.1d5e216a.Christoph.Pleger@cs.uni-dortmund.de>
In-Reply-To: <20070706113618.1d5e216a.Christoph.Pleger@cs.uni-dortmund.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707061458.19838.surenkarapetyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 July 2007 14:36:18 Christoph Pleger wrote:
> Hello,
>
> > In recent kernels both PATA and SATA (SCSI too) drives are handled by
> > libata  library. It calls all the drives sd* .
>
> If so, what about the use of hdparm then? I could not change parameters
> like DMA, MultSectIO and 32-Bit support with hdparm. sdparm also did not
> do that work.
>
> Regards
>   Christoph
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

There was a discussion about this on 
http://www.redhat.com/archives/fedora-devel-list/2007-April/msg01079.html
Which concludes with what Alan Cox wrote.
"In DMA modes the 32bit I/O feature and multi-sector mode are not used. For
the moment libata also only supports 32bit PIO on some controllers and for 
those
it si handled automatically. Over time it may well gain 32bit support for 
more,
but again the goal is it will be entirely automatically done if so."
