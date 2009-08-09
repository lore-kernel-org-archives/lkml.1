Return-Path: <linux-kernel-owner+w=401wt.eu-S1751591AbZHIMJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591AbZHIMJP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 08:09:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbZHIMJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 08:09:14 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53304 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbZHIMJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 08:09:13 -0400
Date: Sun, 9 Aug 2009 14:09:02 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>, gregkh@suse.de,
       Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based
	/dev
Message-ID: <20090809120902.GC1338@ucw.cz>
References: <20090805171513.GA10443@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090805171513.GA10443@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> --- /dev/null
> +++ b/drivers/base/devtmpfs.c
> @@ -0,0 +1,367 @@
> +/*
> + * devtmpfs - kernel-maintained tmpfs-based /dev
> + *
> + * Copyright (C) 2009, Kay Sievers <kay.sievers@vrfy.org>
> + *

I'd expect GPL notice here...

> +#if defined CONFIG_DEVTMPFS_MOUNT
> +static int dev_mount = 1;
> +#else
> +static int dev_mount;
> +#endif


A bit too many config options?

> +#ifdef CONFIG_BLOCK
> +static inline int is_blockdev(struct device *dev)
> +{
> +	return dev->class == &block_class;
> +}
> +#else
> +static inline int is_blockdev(struct device *dev) { return 0; }

Should this go to header somewhere?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
