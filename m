Return-Path: <linux-kernel-owner+w=401wt.eu-S1760243AbZASVs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760243AbZASVs1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 16:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754984AbZASVsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 16:48:12 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:2911 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467AbZASVsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 16:48:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=do9aS/ex0DmAv3bjIZ2/3dre79UfdXoiwxA/xJOSLDhzH4cekzKFLQZh+sCxdQVLsh
         Rr5viv4lQfHB+LhCU7KYDnCP1uQVi7imFTVkvKpp4+bZuXHyEQIUxz+IkEu7o6nOpQzO
         Jqsuoyiy51uyLnss2ACrbDrrnnciorEcL6nro=
Date: Mon, 19 Jan 2009 22:48:05 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jeff Garzik <jeff@garzik.org>, Frans Pop <elendil@planet.nl>,
       tj@kernel.org, akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] Hibernation: Introduce system_entering_hibernation
Message-ID: <20090119214804.GC6194@nowhere>
References: <20081104062734.GA4420@havoc.gtf.org> <200901192054.55536.rjw@sisk.pl> <20090119212428.GB6194@nowhere> <200901192235.23677.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901192235.23677.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 10:35:22PM +0100, Rafael J. Wysocki wrote:
> On Monday 19 January 2009, Frederic Weisbecker wrote:
> > On Mon, Jan 19, 2009 at 08:54:54PM +0100, Rafael J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > > Introduce boolean function system_entering_hibernation() returning
> > > 'true' during the last phase of hibernation, in which devices are
> > > being put into low power states and the sleep state (for example,
> > > ACPI S4) is finally entered.
> > > 
> > > Some device drivers need such a function to check if the system is
> > > in the final phase of hibernation.  In particular, some SATA drivers
> > > are going to use it for blacklisting systems in which the disks
> > > should not be spun down during the last phase of hibernation (the
> > > BIOS will do that anyway).
> > >
> > 
> > Hi Rafael,
> > 
> > Why not using the power event notifier?
> 
> I'm not sure what you mean exactly, care to elaborate?


Sorry, I just thought about using the pm_notifier to listen on the suspend/resume
events to check the current hibernation state.

 
> Anyway, however, this is a pretty old patch series and I'm not very much
> interested in reworking it once again.  If you think it can be made better,
> please go on. :-)


It was just a suggestion, or more likely a question for curiosity, not really
a criticism since I didn't follow the discussions about these patches and the
problem they solve :-)

Thanks.


> Thanks,
> Rafael

