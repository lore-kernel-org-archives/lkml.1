Return-Path: <linux-kernel-owner+w=401wt.eu-S1762703AbXLQQ1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762703AbXLQQ1Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 11:27:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755016AbXLQQ1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 11:27:14 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:19236 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbXLQQ1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 11:27:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Opt3e07oEDJrDhuvHKvTFhpaZB6/Qg/eL8gkEXCZMlTRz+Lq5QLCdDP1PEuPFbuI7lTfB5bDJCim+y/eb3rfMxOMCbRJcCc6nvTRt0gorDRba7586nLiYMvzdaqRMgnxy/GwQDVWa5wmpaHrLLL9023Mse4UHvxuKVTM0WGJE74=
Message-ID: <3ae72650712170827o21ea5e25v83490b2e73df2aa@mail.gmail.com>
Date: Mon, 17 Dec 2007 17:27:11 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
Subject: Re: [1/4] DST: Distributed storage documentation.
Cc: lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <11979038192980@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11979038181687@2ka.mipt.ru> <11979038192980@2ka.mipt.ru>
X-Google-Sender-Auth: 0b213334c0e3a6e0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 17, 2007 4:03 PM, Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:

> +++ b/Documentation/dst/sysfs.txt
> @@ -0,0 +1,33 @@
> +This file describes sysfs files created for each storage.
> +
> +1. Per-storage files.
> +Each storage has its own dir /sysfs/devices/$storage_name,

> +2. Per-node files.
> +Node's files are located in /sysfs/devices/$storage_name/n-$start-$cookie

As already pointed out last time, you can't reference /sys/devices/ directly,
please use the path from the bus/class directory which points there.

Thanks,
Kay
