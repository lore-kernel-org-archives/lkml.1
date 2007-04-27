Return-Path: <linux-kernel-owner+w=401wt.eu-S1755486AbXD0IKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbXD0IKw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 04:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755487AbXD0IKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 04:10:51 -0400
Received: from ns2.suse.de ([195.135.220.15]:45953 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755484AbXD0IKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 04:10:49 -0400
Subject: Re: 2.6.21-rc7-mm2 -- gnome-power-manager always shows the power
	as coming from AC
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Miles Lane <miles.lane@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       Vladimir Lebedev <vladimir.p.lebedev@intel.com>,
       Len Brown <lenb@kernel.org>
In-Reply-To: <a44ae5cd0704261552o20e01dabsdac02dfd7c28f16a@mail.gmail.com>
References: <a44ae5cd0704261213o37944b46u5dbdd231fc6a2490@mail.gmail.com>
	 <20070426142824.9da91feb.akpm@linux-foundation.org>
	 <a44ae5cd0704261552o20e01dabsdac02dfd7c28f16a@mail.gmail.com>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Fri, 27 Apr 2007 10:10:47 +0200
Message-Id: <1177661447.1231.689.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-26 at 15:52 -0700, Miles Lane wrote:
> On 4/26/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Thu, 26 Apr 2007 12:13:00 -0700 "Miles Lane" <miles.lane@gmail.com> wrote:
> >
> > > One possible issue is that /proc/acpi/power_resource/ is an empty directory.
> > > Otherwise, the ACPI information seems to be fine:
> > >
> > > # cat /proc/acpi/ac_adapter/ACAD/state
> > > state:                   on-line
> > > # cat /proc/acpi/ac_adapter/ACAD/state
> > > state:                   off-line
> > >
> > > # cat /proc/acpi/battery/BAT0/state
> > > present:                 yes
> > > capacity state:          ok
> > > charging state:          discharging
> > > present rate:            0 mA
> > > remaining capacity:      7072 mAh
> > > present voltage:         12487 mV
> > >
> > > When I unplug the power cable, /proc/acpi/battery/BAT0/state (present
> > > rate) shows that current flowing from the battery.
> > >
> > > # cat /proc/acpi/button/lid/LID0/state
> > > state:      closed
> > > # cat /proc/acpi/button/lid/LID0/state
> > > state:      open
> >
> > hm, I'm looking suspiciously at "ACPI: Cache battery status instead of
> > re-evaluating AML".
> >
> > What sort of machine is this?
> 
> HP Pavilion dv1240us
Does compiling CONFIG_MOUSE_PS2= as module (and best not loading it) or
compiling it out help?

   Thomas

