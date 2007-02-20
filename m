Return-Path: <linux-kernel-owner+w=401wt.eu-S1030452AbXBTVph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030452AbXBTVph (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 16:45:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030455AbXBTVph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 16:45:37 -0500
Received: from an-out-0708.google.com ([209.85.132.251]:37842 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030452AbXBTVpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 16:45:36 -0500
Message-ID: <5640c7e00702201345n409d5c4btf978610541f866c2@mail.gmail.com>
Date: Wed, 21 Feb 2007 10:45:35 +1300
From: "Ian McDonald" <ian.mcdonald@jandi.co.nz>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: [PATCH] pci: allow multiple calls to pcim_pin_device()
Cc: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>, gregkh@suse.de,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>
In-Reply-To: <20070220082839.GN1625@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5640c7e00702181153q44678861q9963e7e2de00be8@mail.gmail.com>
	 <200702182158.13429.bzolnier@gmail.com>
	 <5640c7e00702182000p26f1ca8n15c1edcd8b3134a1@mail.gmail.com>
	 <200702191247.03274.bzolnier@gmail.com>
	 <20070220082839.GN1625@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/20/07, Tejun Heo <htejun@gmail.com> wrote:
> Sanity check in pcim_pin_device() was too restrictive in that it
> didn't allow multiple calls to the function, which is against the
> devres philosohpy of fire-and-forget.  Track pinned status separately
> and allow pinning multiple times.
>
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> ---
> It was an actual bug in pcim_pin_device() implementation.  Thanks for
> spotting this.  :-)
>
> Ian McDonald, please verify your warning goes away with this patch.

Yes it does. Thanks for sorting.
>
> Greg, please forward this patch upstream once Ian acks it.
>
Acked-by: Ian McDonald <ian.mcdonald@jandi.co.nz>
-- 
Web: http://wand.net.nz/~iam4
Blog: http://iansblog.jandi.co.nz
WAND Network Research Group
