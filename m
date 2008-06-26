Return-Path: <linux-kernel-owner+w=401wt.eu-S1756460AbYFZJj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460AbYFZJj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 05:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754306AbYFZJjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 05:39:20 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:5524 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210AbYFZJjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 05:39:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=ZunC5fAKT5HcGXqas1aW5QU9llgT8uLJA+da2P8AdGTaiADThXUGbURPBmN8L/2dS8
         JqszsqpJ0a5Fw4cNXsfa5RYTtPGg9toONVfDu7guFEap6sLuDKJZRCQY22kgkFJkOhj1
         8qtm6DO4Kg6j6tZQr4yLfYft1V/I9DtiMVhiU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: benh@kernel.crashing.org
Subject: Re: [PATCH 1/4] ide-pmac: media-bay support fixes
Date: Thu, 26 Jun 2008 11:40:39 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200806162124.43005.bzolnier@gmail.com> <200806261051.34733.bzolnier@gmail.com> <1214470868.8011.455.camel@pasglop>
In-Reply-To: <1214470868.8011.455.camel@pasglop>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806261140.39531.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 June 2008, Benjamin Herrenschmidt wrote:
> On Thu, 2008-06-26 at 10:51 +0200, Bartlomiej Zolnierkiewicz wrote:
> > 
> > The latest patches in one place:
> > 
> > http://www.kernel.org/pub/linux/kernel/people/bart/pata-2.6/
> > 
> > pmac-media-bay-support-fixes-take-3.patch
> > pmac-store-pmif-instead-of-hwif-in-driver_data-take-2.patch
> > pmac-add-init_dev-method-take-3.patch
> > pmac-move-ide_find_port-call-to-pmac_ide_setup_device-take-2.patch
> > 
> > IMO they are quite small and straightforward so setting git tree would
> > be overdoing it but if there are still problems I will set one.
> 
> That's ok, just tell me a tree and an SHA1 ID of a commit on top of
> which they apply, that will make my life easier :-)

They are still for *linux-next* (since they depend on other IDE changes)
and apply fine on top of -20080625.

SHA1 ID is: 9ab50ba2f4958b593802ce91395d07148b611b71 but I don't know
whether it is useful in linux-next context.

> I'll test them tomorrow morning.

Thanks.

Bart
