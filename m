Return-Path: <linux-kernel-owner+w=401wt.eu-S1753398AbZA0KJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbZA0KJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 05:09:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbZA0KJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 05:09:23 -0500
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:50351 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbZA0KJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 05:09:22 -0500
Date: Tue, 27 Jan 2009 11:09:16 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Tomas Carnecky <tom@dbservice.com>, bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bug 12492] Re: [patch 1/2] stop_machine: introduce
 stop_machine_create/destroy.
Message-ID: <20090127110916.4a7dbec4@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20090127015202.486dd1af.akpm@linux-foundation.org>
References: <20081222113629.080104676@de.ibm.com>
	<20081222114529.601526881@de.ibm.com>
	<20090127000432.65042e85.akpm@linux-foundation.org>
	<20090127015202.486dd1af.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2009 01:52:02 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 27 Jan 2009 00:04:32 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
> >   Commit 9ea09af3bd3090e8349ca2899ca2011bd94cda85 introduced a
> >   regression that caused the kernel to fail to suspend.  The 'sleeping'
> >   LED on the laptop just keeps blinking and the laptop never shuts
> >   down.  I think this was eventually fixed because with 2.6.29-rc1 and
> >   -rc2 the laptop suspends fine, but fails to resume.  When I try to
> >   resume, all I see is a blinking cursor in the top left corner of the
> >   screen.
> > 
> >   I'm using acpi_sleep=s3_bios,s3_mode, suspending using a script
> >   that does: echo mem > /sys/power/state.
> 
> hm.  Re-reading this, it seems to be saying that
> 9ea09af3bd3090e8349ca2899ca2011bd94cda85 might be innocent, and that
> some other patch might have caused the resume regression?

Yes, I already updated the bugzilla entry at kernel.org:

The bug introduced with the introduction of stop_machine_create/destroy
was fixed with a0e280e0f33f6c859a235fb69a875ed8f3420388
"stop_machine/cpu hotplug: fix disable_nonboot_cpus".
Must be something else.
