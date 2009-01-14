Return-Path: <linux-kernel-owner+w=401wt.eu-S1758763AbZANH5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763AbZANH5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 02:57:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754972AbZANH53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 02:57:29 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:65048 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654AbZANH52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 02:57:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=IVkXnt5bkynyDlmgrrt0ZrKbFeoUso6oDLnCh8m806dqWkd2WONGKwxhQVslGVmgAu
         VAzuvw5hLl4ZdDHEH+viISLtVeZPTaHIjX/EgBHZhMxHqmBMpcLGgEyfqi1kcdWr3md+
         RFlYJh9hjsNpNXVfsSUSrEs5i3LakEMno8zsE=
Message-ID: <84144f020901132357h7fbac614yb95557d2fcc7c316@mail.gmail.com>
Date: Wed, 14 Jan 2009 09:57:26 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Roland Dreier" <rdreier@cisco.com>
Subject: Re: [PATCH] btrfs: Remove extra KERN_INFO in the middle of a line
Cc: "Chris Mason" <chris.mason@oracle.com>, linux-kernel@vger.kernel.org
In-Reply-To: <adamydukawi.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <adamydukawi.fsf@cisco.com>
X-Google-Sender-Auth: 46472d578b0b7a79
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roland,

On Wed, Jan 14, 2009 at 2:07 AM, Roland Dreier <rdreier@cisco.com> wrote:
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index b187b53..2280d19 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -577,7 +577,7 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
>                       *(unsigned long long *)disk_super->fsid,
>                       *(unsigned long long *)(disk_super->fsid + 8));
>        }
> -       printk(KERN_INFO "devid %llu transid %llu %s\n",
> +       printk("devid %llu transid %llu %s\n",

We have KERN_CONT for this.

>               (unsigned long long)devid, (unsigned long long)transid, path);
>        ret = device_list_add(path, disk_super, devid, fs_devices_ret);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
