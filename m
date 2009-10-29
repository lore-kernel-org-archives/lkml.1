Return-Path: <linux-kernel-owner+w=401wt.eu-S1753170AbZJ2P54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbZJ2P54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 11:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbZJ2P54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 11:57:56 -0400
Received: from cantor.suse.de ([195.135.220.2]:38184 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285AbZJ2P5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 11:57:55 -0400
Message-ID: <4AE9BBC6.3070304@suse.de>
Date: Thu, 29 Oct 2009 16:59:02 +0100
From: Tejun Heo <teheo@suse.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH 1/3] Fix updating of named attribute groups
References: <20091020054740.GC29158@parisc-linux.org> <20091020054946.GD29158@parisc-linux.org>
In-Reply-To: <20091020054946.GD29158@parisc-linux.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> +		if (update) {
> +			sd = sysfs_get_dirent(kobj->sd, grp->name);
> +			if (!sd)
> +				return -ENOENT;
> +		} else {
> +			error = sysfs_create_subdir(kobj, grp->name, &sd);
> +			if (error)
> +				return error;
> +			sysfs_get(sd);
> +		}
> +	} else {
> +		sd = sysfs_get(kobj->sd);
> +	}

nitpick: the last braces aren't necessary.

-- 
tejun
