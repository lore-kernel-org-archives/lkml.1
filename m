Return-Path: <linux-kernel-owner+w=401wt.eu-S1752691AbYHNX51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbYHNX51 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 19:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbYHNX45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 19:56:57 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:38706 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbYHNX44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 19:56:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=svWeURm2P+vTkjK1eAXj5p1h2bKDmq1rBf4byvLXnEgeA7LoDBK3S8eZ9qU3bfXxf6
         mb4c5wOcT883W9rwjI0y9rvtOSSx4TnmuhAxgBo+EZvPdMxVK3lGX8HrYENTkr2txiPD
         Lr+r8AbqhGAmJHW0aAx1W5/nkew7zIUuYhTV8=
Message-ID: <9929d2390808141656g1896657fm6802c520b036cacc@mail.gmail.com>
Date: Thu, 14 Aug 2008 16:56:54 -0700
From: "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 3/3] Adapt the e100 driver to the reworked PCI PM
Cc: netdev@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       "Jeff Garzik" <jeff@garzik.org>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "pm list" <linux-pm@lists.linux-foundation.org>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       "Stephen Hemminger" <stephen.hemminger@vyatta.com>
In-Reply-To: <200808142340.25574.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200808142335.56644.rjw@sisk.pl> <200808142340.25574.rjw@sisk.pl>
X-Google-Sender-Auth: 416deae7a9acf547
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 2:40 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> [Note: I have no hardware to test this patch, but it seems pretty
> straightforward.]
>
> Adapt the e100 driver to the reworked PCI PM
>
> * Use device_set_wakeup_enable() and friends as needed
> * Use pci_pme_active() to clear PME_Status and disable PME#
> * Use the observation that it is sufficient to call pci_enable_wake()
>  once, unless it fails
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/net/e100.c |   20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
>

We have tested the patch in our labs and systems wake from S5 just fine.

Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

-- 
Cheers,
Jeff
