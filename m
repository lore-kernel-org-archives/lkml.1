Return-Path: <linux-kernel-owner+w=401wt.eu-S1756330AbXJBVTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330AbXJBVTz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 17:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754863AbXJBVTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 17:19:42 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:30390 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942AbXJBVTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 17:19:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=NehSenHOfuisCM++jSi+aONrrRZz5GW4GDNAf5C0FSxP72Ggv3IKk2aN6D8KG1AyV9YTv8Yh7ympbqxWbv0H6EnH94xyUCcR7wh8dXRRDtaFqo+yRJmV1p+5K06V7Q4pDrNNcnX4ByriC1fN37/zWctgufGNfY7A4RPuZfwJ/2g=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 4/4] hpt366: MWDMA filter for SATA cards (take 2)
Date: Tue, 2 Oct 2007 22:26:10 +0200
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200709300004.43335.sshtylyov@ru.mvista.com> <200710012312.45552.bzolnier@gmail.com> <470237E3.2020108@ru.mvista.com>
In-Reply-To: <470237E3.2020108@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710022226.10687.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 October 2007, Sergei Shtylyov wrote:
> Bartlomiej Zolnierkiewicz wrote:
> 
> >>The Marvell bridge chips used on HighPoint SATA cards do not seem to support
> >>the MWDMA modes (at least that caould be seen in their so-called drivers :-),
> >>so the driver needs to account for this -- to achieve this:
> 
> >>- add mdma_filter() method from the original patch by Bartlomiej Zolnierkewicz
> >> with his consent,
> 
> >> also adding the method callout to ide_rate_filter();
> 
>     Ugh, forgot to remove this part -- it's no longer true.

Thanks for the hint, I fixed it locally.

Bart
