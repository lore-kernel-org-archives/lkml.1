Return-Path: <linux-kernel-owner+w=401wt.eu-S1751479AbZHZOyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479AbZHZOyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 10:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbZHZOyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 10:54:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54403 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751247AbZHZOyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 10:54:08 -0400
Date: Wed, 26 Aug 2009 07:53:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>
Subject: Re: 2.6.31-rc7-git2: Reported regressions 2.6.29 -> 2.6.30
Message-Id: <20090826075337.4230d82c.akpm@linux-foundation.org>
In-Reply-To: <b170af450908260147o60427997ne6b9872198893c41@mail.gmail.com>
References: <JuOd1ZASH0B.A.YGB.0zGlKB@chimera>
	<b170af450908260147o60427997ne6b9872198893c41@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Aug 2009 10:47:13 +0200 Rafa__ Mi__ecki <zajec5@gmail.com> wrote:

> 2009/8/25 Rafael J. Wysocki <rjw@sisk.pl>:
> > Bug-Entry __ __ __ : http://bugzilla.kernel.org/show_bug.cgi?id=13514
> > Subject __ __ __ __ : acer_wmi causes stack corruption
> > Submitter __ __ __ : Rus <harbour@sfinx.od.ua>
> > Date __ __ __ __ __ __: 2009-06-12 08:13 (75 days old)
> 
> It has patch, just Len doesn't seem to... don't know, read the topic?
> http://patchwork.kernel.org/patch/29082/
> 
> Can we ping Len somehow to push this patch directly to Linus's tree?
> 

I'm not seeing any linux-acpi emails from Len since August 14.

So I merged this patch and shall send it along with

thermal_sys-check-get_temp-return-value.patch
acpi-dont-call-acpi_processor_init-if-acpi-is-disabled.patch

in to Linus today.
