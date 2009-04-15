Return-Path: <linux-kernel-owner+w=401wt.eu-S1758242AbZDOHlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbZDOHlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 03:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbZDOHlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 03:41:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:18910 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbZDOHlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 03:41:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,191,1239001200"; 
   d="scan'208";a="448029782"
Subject: Re: Linux 2.6.30-rc2
From: Zhang Rui <rui.zhang@intel.com>
To: yakui_zhao <yakui.zhao@intel.com>
Cc: Brice Goglin <Brice.Goglin@ens-lyon.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
In-Reply-To: <1239780780.5564.130.camel@localhost.localdomain>
References: <alpine.LFD.2.00.0904141628570.4132@localhost.localdomain>
	 <49E57CEA.1020401@ens-lyon.org>
	 <1239780780.5564.130.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 15 Apr 2009 15:41:56 +0800
Message-Id: <1239781316.7661.356.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-15 at 15:33 +0800, yakui_zhao wrote:
> On Wed, 2009-04-15 at 14:21 +0800, Brice Goglin wrote:
> > CC [M]  drivers/acpi/video.o
> >   <no warning>
> >   ...
> >   LD      .tmp_vmlinux1
> > drivers/built-in.o: In function `intel_opregion_init':
> > (.text+0x813e2): undefined reference to `acpi_video_register'
> > make: *** [.tmp_vmlinux1] Error 1
> Will you please try the patch in the comment #16/#21 of 
> http://bugzilla.kernel.org/show_bug.cgi?id=13065 ?
> 
you must mean http://bugzilla.kernel.org/show_bug.cgi?id=13048 .

Brice,
we already have two patches to fix this issue, but they're still under
discussion http://marc.info/?l=linux-acpi&m=123967821529829&w=2

thanks,
rui

> Thanks.
> > 
> > I think I had the same with -rc1.
> > 
> > .config is attached
> > 
> > Cheers,
> > Brice
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

