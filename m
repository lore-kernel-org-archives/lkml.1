Return-Path: <linux-kernel-owner+w=401wt.eu-S934061AbXEKU6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934061AbXEKU6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 16:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760767AbXEKU6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 16:58:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60737 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760015AbXEKU6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 16:58:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 3/3] clockevents: Fix resume logic - updated version
Date: Fri, 11 May 2007 23:02:46 +0200
User-Agent: KMail/1.9.5
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
       linux-acpi@vger.kernel.org
References: <20070430102837.748238000@linutronix.de> <200705112210.25397.rjw@sisk.pl> <20070511132846.5ebf4437.akpm@linux-foundation.org>
In-Reply-To: <20070511132846.5ebf4437.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705112302.47726.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 11 May 2007 22:28, Andrew Morton wrote:
> On Fri, 11 May 2007 22:10:24 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > > > Index: linux-2.6.21/drivers/acpi/hardware/hwsleep.c
> > > > ===================================================================
> > > > --- linux-2.6.21.orig/drivers/acpi/hardware/hwsleep.c
> > > > +++ linux-2.6.21/drivers/acpi/hardware/hwsleep.c
> > > > @@ -200,10 +200,10 @@ acpi_status acpi_enter_sleep_state_prep(
> > > >  		return_ACPI_STATUS(status);
> > > >  	}
> > > >  
> > > > -	status = acpi_evaluate_object(NULL, METHOD_NAME__GTS, &arg_list, NULL);
> > > > +	/*status = acpi_evaluate_object(NULL, METHOD_NAME__GTS, &arg_list, NULL);
> > > >  	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
> > > >  		return_ACPI_STATUS(status);
> > > > -	}
> > > > +	}*/
> > > >  
> > > >  	/* Setup the argument to _SST */
> > > >  
> > > 
> > > I tested this against Thomas's original patch (below).  Still hangs, in the
> > > same way.
> > 
> > Well, I'm out of ideas. :-(
> > 
> > Could you please send me the Vaio's DSDT?
> 
> Maybe I should send you the Vaio ;)

Well, machines with so much potential of exposing problems are priceless. ;-)

> I have this 1999-era pre-ACPI, pre-everything-else Dual-PIII-based
> Supermicro machine and it just *always* works.  Sigh.
> 
> 
> hm, Fedora don't seem to want to give me an RPM which contains acpidump and
> all the yum servers are featuring scrogged checksums.  I could build it, I
> guess, but there's a principle involved ;)
> 
> http://userweb.kernel.org/~akpm/dsdt is /proc/acpi/dsdt.  Is that OK?

Yes, thanks.
