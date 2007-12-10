Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbXLJMv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbXLJMv7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 07:51:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbXLJMvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 07:51:46 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:14815 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbXLJMvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 07:51:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=RaEFBqn8V/TzAE0Lqkm0S+M6TM1y0Te0WQA1cY17c4JMIiFc/u/cCkWmu8CeLBGpyLaXgDr066XrKK+J051I0yJZzcPDfBI+ASS+N/2y18iNbtjJnyF59y0vw4OGS90SHses5YuB+GWCTZY3+TyMhPvHesqwMZPymR9P7AluQo4=
Message-ID: <3ae72650712100451h6a84d6cfs9b3a2954c13c4612@mail.gmail.com>
Date: Mon, 10 Dec 2007 13:51:43 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
Subject: Re: [1/4] DST: Distributed storage documentation.
Cc: lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, "Greg KH" <greg@kroah.com>
In-Reply-To: <11972872501664@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11972872493977@2ka.mipt.ru> <11972872501664@2ka.mipt.ru>
X-Google-Sender-Auth: 9aef99291082a5de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 10, 2007 12:47 PM, Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> diff --git a/Documentation/dst/sysfs.txt b/Documentation/dst/sysfs.txt
> new file mode 100644
> index 0000000..79d79dc
> --- /dev/null
> +++ b/Documentation/dst/sysfs.txt
> @@ -0,0 +1,30 @@
> +This file describes sysfs files created for each storage.
> +
> +1. Per-storage files.
> +Each storage has its own dir /sysfs/devices/$storage_name,

It's always /sys/devices/.

> +which contains following files:
> +
> +alg - contains name of the algorithm used to created given storage
> +name - name of the storage
> +nodes - map of the storage (list of nodes and their sizes and starts)
> +remove_all_nodes - writable file which allows to remove all nodes from given
> +       storage
> +n-$start-$cookie - per node directory, where
> +       $start - start of the given node in sectors,
> +       $cookie - unique node's id used by DST
> +
> +2. Per-node files.
> +Node's files are located in /sysfs/devices/$storage_name/n-$start-$cookie
> +directory, described above.

To which class or bus do the devices you create belong? Care to show a
"tree" or "ls -la" of the device?

Kay
