Return-Path: <linux-kernel-owner+w=401wt.eu-S1752771AbYKMOof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbYKMOof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 09:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751077AbYKMOo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 09:44:26 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:8359 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbYKMOo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 09:44:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=NUrXvzCsBcj9diG6isTeWxRLG2WzImR/Y86jDq9uPUY4/Y4I0gJpO5hblguUoZOOwc
         zvxn5uqARO/10cITHsaTR9hpjExc2MyTbzGDXyLZCTDJklgmRoogUH2Eh9LUHG+ypZ7I
         nMSBLXAycPCaosJNPntloi16ajx8VIHcD50m4=
Message-ID: <8bd0f97a0811130644q47260290pdf5af54dd8967af9@mail.gmail.com>
Date: Thu, 13 Nov 2008 09:44:25 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Atsushi Nemoto" <anemo@mba.ocn.ne.jp>
Subject: Re: [PATCH] mtd/physmap: use parse_mtd()
Cc: vapier@gentoo.org, linux-mtd@lists.infradead.org, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081113.225101.14979944.anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1226533133-7405-1-git-send-email-vapier@gentoo.org>
	 <1226533189-8492-1-git-send-email-vapier@gentoo.org>
	 <20081113.225101.14979944.anemo@mba.ocn.ne.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2008 at 08:51, Atsushi Nemoto wrote:
> On Wed, 12 Nov 2008 18:39:48 -0500, Mike Frysinger wrote:
>> Call parse_mtd() to handle partition/device registration rather than doing
>> it all ourself.
>>
>> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>> ---
>>  drivers/mtd/maps/physmap.c |   21 +--------------------
>>  1 files changed, 1 insertions(+), 20 deletions(-)
>
> You should adjust physmap_flash_remove() too.
>
> * remove kfree(info->parts)
> * call del_mtd_partitions() or del_mtd_device()
>
> Maybe del_parsed_mtd() or something is required?

yeah, this last bit sounds good
-mike
