Return-Path: <linux-kernel-owner+w=401wt.eu-S1756133AbZJ2BAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbZJ2BAd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 21:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756037AbZJ2BAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 21:00:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:49783 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756025AbZJ2BAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 21:00:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,642,1249282800"; 
   d="scan'208";a="462442680"
Date: Thu, 29 Oct 2009 09:00:35 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: Alex Chiang <achiang@hp.com>
Cc: "lenb@kernel.org" <lenb@kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 0/6] ACPI: dock: code hygiene
Message-ID: <20091029010035.GA29998@sli10-desk.sh.intel.com>
References: <20091019211132.5412.80438.stgit@bob.kio> <20091029000743.GA3602@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091029000743.GA3602@ldl.fc.hp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 29, 2009 at 08:07:43AM +0800, Alex Chiang wrote:
> Hi Len, Shaohua,
> 
> Any comments on this patch series?
> 
> I did fat-finger Shaohua's email address when I sent out v4, but
> I thought I bounced all the mails to him privately, off-list.
I'm ok with the series.

Thanks,
Shaohua
> * Alex Chiang <achiang@hp.com>:
> > This is v4 of a modest attempt to clean up the dock driver.
> > 
> > As before, compile tested only, since I don't have any machines
> > that provide _DCK.
> > 
> > Thanks.
> > /ac
> > 
> > v3 -> v4:
> > 	- defensively code in case sysfs_create_group() fails and
> > 	  sysfs_remove_group() can't handle removing a non-existent group;
> > 	  suggested by Dmitry Torokhov
> > 
> > v2 -> v3:
> > 	- now using an attribute_group, as suggested by Dmitry Torokhov
> > 
> > v1 -> v2:
> > 	- changed how we add platform device data, based on Shaohua Li's
> >   	  review
> > ---
> > 
> > Alex Chiang (6):
> >       ACPI: dock: convert sysfs attributes to an attribute_group
> >       ACPI: dock: combine add|alloc_dock_dependent_device
> >       ACPI: dock: remove global 'dock_device_name'
> >       ACPI: dock: dock_add - hoist up platform_device_register_simple()
> >       ACPI: dock: add struct dock_station * directly to platform device data
> >       ACPI: dock: minor whitespace and style cleanups
> > 
> > 
> >  drivers/acpi/dock.c |  266 ++++++++++++++++++---------------------------------
> >  1 files changed, 93 insertions(+), 173 deletions(-)
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
