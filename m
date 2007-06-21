Return-Path: <linux-kernel-owner+w=401wt.eu-S1759588AbXFUVzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759588AbXFUVzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 17:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757754AbXFUVzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 17:55:07 -0400
Received: from www.osadl.org ([213.239.205.134]:33376 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757362AbXFUVzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 17:55:05 -0400
Subject: Re: ACPI Regression on Dell E1501
From: Thomas Gleixner <tglx@linutronix.de>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Tim Gardner <tim.gardner@canonical.com>, lenb@kernel.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <467AF204.3060805@redhat.com>
References: <467AE7E1.4050805@canonical.com>  <467AF204.3060805@redhat.com>
Content-Type: text/plain
Date: Thu, 21 Jun 2007 23:55:02 +0200
Message-Id: <1182462902.3316.105.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-21 at 17:47 -0400, Chuck Ebbert wrote:
> On 06/21/2007 05:04 PM, Tim Gardner wrote:
> > Hi,
> > 
> > Commit e9e2cdb412412326c4827fc78ba27f410d837e6e breaks boot on a Dell
> > E1501 unless 'acpi=off' is specified (also tried nolapic and nohpet but
> > it made no substantive difference). This laptop is an 'AMD Turion(tm) 64
> > X2 Mobile Technology TL-50' CPU, but its booting 32 bit SMP (make
> > defconfig). No kernel built after this commit works for this platform.
> > 
> > There is no crash output, it just wedges after 'NET: Registered protocol
> > family 2'.
> > 
> > How can I debug this problem?
> 
> That'll be fun.
> 
> That's:
> 
> 	[PATCH] clockevents: i386 drivers
> 
> [Author cc: added]

I'm going nuts on this. 

Tim, 

1.) are you booting a 32bit or a 64 bit kernel ?

2.) Can you please try 2.6.22-rc5 + 
http://www.tglx.de/projects/hrtimers/2.6.22-rc5/patch-2.6.22-rc5-hrt1.patch
	whether this makes any difference 

Thanks,

	tglx




