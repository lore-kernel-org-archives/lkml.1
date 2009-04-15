Return-Path: <linux-kernel-owner+w=401wt.eu-S1755046AbZDOHbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbZDOHbq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 03:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751438AbZDOHbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 03:31:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:11888 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbZDOHbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 03:31:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,191,1239001200"; 
   d="scan'208";a="403273080"
Subject: Re: Linux 2.6.30-rc2
From: yakui_zhao <yakui.zhao@intel.com>
To: Brice Goglin <Brice.Goglin@ens-lyon.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
In-Reply-To: <49E57CEA.1020401@ens-lyon.org>
References: <alpine.LFD.2.00.0904141628570.4132@localhost.localdomain>
	 <49E57CEA.1020401@ens-lyon.org>
Content-Type: text/plain
Organization: Intel Open Source Technology Center
Date: Wed, 15 Apr 2009 15:33:00 +0800
Message-Id: <1239780780.5564.130.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-15 at 14:21 +0800, Brice Goglin wrote:
> CC [M]  drivers/acpi/video.o
>   <no warning>
>   ...
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `intel_opregion_init':
> (.text+0x813e2): undefined reference to `acpi_video_register'
> make: *** [.tmp_vmlinux1] Error 1
Will you please try the patch in the comment #16/#21 of 
http://bugzilla.kernel.org/show_bug.cgi?id=13065 ?

Thanks.
> 
> I think I had the same with -rc1.
> 
> .config is attached
> 
> Cheers,
> Brice
> 

