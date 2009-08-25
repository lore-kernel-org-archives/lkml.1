Return-Path: <linux-kernel-owner+w=401wt.eu-S1754331AbZHYDiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331AbZHYDiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 23:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754177AbZHYDiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 23:38:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:17166 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754131AbZHYDiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 23:38:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,269,1249282800"; 
   d="scan'208";a="720281566"
Subject: Re: [RFC] [PATCH v3 1/2] introduce ALS sysfs class
From: Zhang Rui <rui.zhang@intel.com>
To: Greg KH <greg@kroah.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>
In-Reply-To: <20090821150825.GC10667@kroah.com>
References: <1250671229.17853.51.camel@rzhang-dt>
	 <20090819160144.GB1020@kroah.com> <1250819647.17853.144.camel@rzhang-dt>
	 <20090821150825.GC10667@kroah.com>
Content-Type: text/plain
Date: Tue, 25 Aug 2009 11:36:52 +0800
Message-Id: <1251171412.3483.74.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-21 at 23:08 +0800, Greg KH wrote:
> On Fri, Aug 21, 2009 at 09:54:07AM +0800, Zhang Rui wrote:
> > ---
> >  Documentation/ABI/testing/sysfs-class-als |   47 +++++
> >  drivers/Kconfig                           |    2 
> >  drivers/Makefile                          |    1 
> >  drivers/als/Kconfig                       |   10 +
> >  drivers/als/Makefile                      |    5 
> >  drivers/als/als_sys.c                     |  256 ++++++++++++++++++++++++++++++
> >  include/linux/als_sys.h                   |   57 ++++++
> 
> Does this file really need to be in include/linux/ ?
> 
> Or could you just put it into drivers/als/ and it would be fine?
> 
I don't think so, because all the other native ALS drivers like ACPI ALS
driver should depend on this header file.

thanks,
rui

