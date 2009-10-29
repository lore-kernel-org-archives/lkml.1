Return-Path: <linux-kernel-owner+w=401wt.eu-S1755777AbZJ2AHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777AbZJ2AHl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 20:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755336AbZJ2AHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 20:07:40 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:46190 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282AbZJ2AHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 20:07:39 -0400
Date: Wed, 28 Oct 2009 18:07:43 -0600
From: Alex Chiang <achiang@hp.com>
To: shaohua.li@intel.com, lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/6] ACPI: dock: code hygiene
Message-ID: <20091029000743.GA3602@ldl.fc.hp.com>
References: <20091019211132.5412.80438.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091019211132.5412.80438.stgit@bob.kio>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len, Shaohua,

Any comments on this patch series?

I did fat-finger Shaohua's email address when I sent out v4, but
I thought I bounced all the mails to him privately, off-list.

Thanks,
/ac

* Alex Chiang <achiang@hp.com>:
> This is v4 of a modest attempt to clean up the dock driver.
> 
> As before, compile tested only, since I don't have any machines
> that provide _DCK.
> 
> Thanks.
> /ac
> 
> v3 -> v4:
> 	- defensively code in case sysfs_create_group() fails and
> 	  sysfs_remove_group() can't handle removing a non-existent group;
> 	  suggested by Dmitry Torokhov
> 
> v2 -> v3:
> 	- now using an attribute_group, as suggested by Dmitry Torokhov
> 
> v1 -> v2:
> 	- changed how we add platform device data, based on Shaohua Li's
>   	  review
> ---
> 
> Alex Chiang (6):
>       ACPI: dock: convert sysfs attributes to an attribute_group
>       ACPI: dock: combine add|alloc_dock_dependent_device
>       ACPI: dock: remove global 'dock_device_name'
>       ACPI: dock: dock_add - hoist up platform_device_register_simple()
>       ACPI: dock: add struct dock_station * directly to platform device data
>       ACPI: dock: minor whitespace and style cleanups
> 
> 
>  drivers/acpi/dock.c |  266 ++++++++++++++++++---------------------------------
>  1 files changed, 93 insertions(+), 173 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
