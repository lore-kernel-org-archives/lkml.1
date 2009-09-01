Return-Path: <linux-kernel-owner+w=401wt.eu-S1752874AbZIAHA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbZIAHA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 03:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbZIAHA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 03:00:58 -0400
Received: from mail-px0-f204.google.com ([209.85.216.204]:49883 "EHLO
	mail-px0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbZIAHA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 03:00:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:message-id;
        b=SvmsLeU1l5+gx6q5T624D8ygtQX8wG57nw8yAjFvhwKhUaROV8zwCCefrgC45Xtnzo
         MFi3Tc1ioshSZivesJy0rOiAR6uSPfyvXnL9qCAqK+PC9lKHa45IDHVYxMEnA92Kw3Ie
         vzWcXyl6dK1mjy4EaXfB1YBLYmZYDKZFmUisI=
Date: Tue, 1 Sep 2009 00:00:55 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <lenb@kernel.org>, linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH V5 0/2] Ambient Light Sensor support
References: <1251706025.3483.159.camel@rzhang-dt> <alpine.LFD.2.00.0908311303340.19451@localhost.localdomain> <20090901070129.F402D526EA5@mailhub.coreip.homeip.net> <1251787667.3483.197.camel@rzhang-dt> <1251787982.3483.201.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251787982.3483.201.camel@rzhang-dt>
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090901073335.818F2526EA5@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 01, 2009 at 02:53:02PM +0800, Zhang Rui wrote:
> On Tue, 2009-09-01 at 14:47 +0800, Zhang Rui wrote:
> > On Tue, 2009-09-01 at 14:28 +0800, Dmitry Torokhov wrote:
> > > On Mon, Aug 31, 2009 at 01:04:35PM -0400, Len Brown wrote:
> > > > I put this in the acpi test tree, with the expectation
> > > > that it will have at least one minor revision update
> > > > before going upstream.
> > > > 
> > > > thanks,
> > > > Len Brown, Intel Open Source Technology Center
> > > > 
> > > 
> > > Breaks build here...
> > > 
> > that's weird.
> > I didn't encounter this problem in my test.
> > 
> PREFIX is defined in include/acpi/acpi_bus.h,
> which has already been included in this driver.
> 
> I got this after applying your patch,
>   CC      drivers/acpi/als.o
> drivers/acpi/als.c:46:1: warning: "PREFIX" redefined
> In file included from drivers/acpi/als.c:30:
> include/acpi/acpi_bus.h:33:1: warning: this is the location of the
> previous definition
> 

[dtor@dtor-d630 work]$ grep -r PREFIX include/acpi/acpi_bus.h
[dtor@dtor-d630 work]$

This is acpi test branch merged with latest pull from Linus plus my
for-linus and next branches that don't touch ACPI code.

-- 
Dmitry
