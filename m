Return-Path: <linux-kernel-owner+w=401wt.eu-S1753048AbZBCF6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbZBCF6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 00:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751588AbZBCF6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 00:58:05 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:41194 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbZBCF6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 00:58:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=AqUuDkkPIayY8WZHd1PSkZgbSwWzjgRiPgm8MF8vuzCZ+UBHEeVwukzkqMr2F0n/vO
         xbajlOF5eHYoEj3/hq+bxiw5IdlnFnQacko4J1jdEZVOP9vUWV/xxpxZhMWBB4Ze4k2E
         VZwZlg/xayEAhJYYAykxpf5UEOOgcfmR+Ms+E=
MIME-Version: 1.0
In-Reply-To: <20090202171312.1559.65827.stgit@linux.site>
References: <20090202171312.1559.65827.stgit@linux.site>
Date: Mon, 2 Feb 2009 21:58:01 -0800
X-Google-Sender-Auth: 9a4ce34603619272
Message-ID: <9929d2390902022158v47bdc745h7267c9c6ad6020e7@mail.gmail.com>
Subject: Re: [PATCH] dca: redesign locks
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Maciej Sosnowski <maciej.sosnowski@intel.com>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 2, 2009 at 9:14 AM, Maciej Sosnowski
<maciej.sosnowski@intel.com> wrote:
> Change spin_locks to irqsave to prevent dead-locks.
> Protect adding and deleting to/from dca_providers list.
> Drop the lock during dca_sysfs_add_req() and dca_sysfs_remove_req() calls
> as they might sleep (use GFP_KERNEL allocation).
>
> Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
> ---
>
>  drivers/dca/dca-core.c |   51 +++++++++++++++++++++++++++++++-----------------
>  1 files changed, 33 insertions(+), 18 deletions(-)
>

Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

-- 
Cheers,
Jeff
