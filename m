Return-Path: <linux-kernel-owner+w=401wt.eu-S932223AbZJSTgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223AbZJSTgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 15:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757259AbZJSTgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 15:36:12 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:26803 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755731AbZJSTgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 15:36:11 -0400
Date: Mon, 19 Oct 2009 13:36:15 -0600
From: Alex Chiang <achiang@hp.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: lenb@kernel.org, shaohua.li@intel.com, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH v3 1/6] ACPI: dock: convert sysfs attributes to an
	attribute_group
Message-ID: <20091019193615.GC23948@ldl.fc.hp.com>
References: <20091016211323.12126.58457.stgit@bob.kio> <20091016211459.12126.60739.stgit@bob.kio> <20091018071630.GC3935@core.coreip.homeip.net> <20091019172138.GB23948@ldl.fc.hp.com> <20091019175616.GA20992@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091019175616.GA20992@core.coreip.homeip.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dmitry Torokhov <dmitry.torokhov@gmail.com>:
> 
> If sysfs_create_group() fails you will go to err_unregister:
> which will try to remove the non-existing group. While the
> current sysfs code is relsilient against such errors it may not
> be so in the future. It is better to have a separate label and
> bypass sysfs_remove_group() if sysfs_create_group() returned
> error.

Yeah, you're right. I was trying to be lazy (everyone else is
doing it!), but I guess you won't let me. ;)

I'll respin.

Thanks for the review.

/ac

