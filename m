Return-Path: <linux-kernel-owner+w=401wt.eu-S1755615AbYFZIud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615AbYFZIud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 04:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755093AbYFZIuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 04:50:21 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:47474 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800AbYFZIuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 04:50:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=tk724X5pmQRV6e1X+Jjf/wfKe49myf9YV521VyIm56MKJBjnd3ThAQntTVkH2seuez
         S6gBU37Keez4rqwaGi+aI3hBApVMYwitp/I+ZoG7j6vPPmw89Z48wTn0wFm2r5Zg7VJI
         TDsAL+0sOrwIIiHDe7Ryj96AWoaefVk/sDJxY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: benh@kernel.crashing.org
Subject: Re: [PATCH 1/4] ide-pmac: media-bay support fixes
Date: Thu, 26 Jun 2008 10:51:34 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200806162124.43005.bzolnier@gmail.com> <200806242055.12042.bzolnier@gmail.com> <1214456094.8011.438.camel@pasglop>
In-Reply-To: <1214456094.8011.438.camel@pasglop>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806261051.34733.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 June 2008, Benjamin Herrenschmidt wrote:
> BTW (usual problem), I'm having a very hard time applying your patches..
> 
> It looks like the 2 replacement ones you sent are no longer against
> whatever merge point I found in linux-next history for your tree, so
> I applied against linux-next 20080620, where 1/4 applies, 2/4 applies
> with offsets and 3 fails...

I see:

http://lkml.org/lkml/2008/6/24/369

it should say patch #3/4 not #2/4

I've just checked and everything still applies fine to 20080625.

> For some reason, every time you send me new patches, I need more time
> figuring out what they are supposed to apply to than actually testing
> them :-)

The latest patches in one place:

http://www.kernel.org/pub/linux/kernel/people/bart/pata-2.6/

pmac-media-bay-support-fixes-take-3.patch
pmac-store-pmif-instead-of-hwif-in-driver_data-take-2.patch
pmac-add-init_dev-method-take-3.patch
pmac-move-ide_find_port-call-to-pmac_ide_setup_device-take-2.patch

IMO they are quite small and straightforward so setting git tree would
be overdoing it but if there are still problems I will set one.

Thanks,
Bart
