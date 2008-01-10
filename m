Return-Path: <linux-kernel-owner+w=401wt.eu-S1758618AbYAJRPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758618AbYAJRPF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 12:15:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754129AbYAJROx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 12:14:53 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53008 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757909AbYAJROw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 12:14:52 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andi Kleen <ak@suse.de>
Subject: Re: [PATCH x86] [15/16] Force __cpuinit on for CONFIG_PM without HOTPLUG_CPU
Date: Thu, 10 Jan 2008 18:17:22 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Adrian Bunk <bunk@kernel.org>, pavel@suse.cz, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
References: <20080103442.621670000@suse.de> <20080110112607.GE28740@does.not.exist> <200801101242.53504.ak@suse.de>
In-Reply-To: <200801101242.53504.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801101817.23522.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 10 of January 2008, Andi Kleen wrote:
> On Thursday 10 January 2008 12:26:07 Adrian Bunk wrote:
> > On Thu, Jan 10, 2008 at 12:15:15PM +0100, Andi Kleen wrote:
> > > > But your patch does:
> > > > 
> > > > +config PM_CPUINIT
> > > > +       bool
> > > > +       depends on PM
> > > 
> > > That is because arch/x86/power/cpu.c where this happens is currently
> > > 
> > > obj-$(CONFIG_PM)                += cpu.o
> > > 
> > > If it was changed to CONFIG_something else then yes that dependency
> > > should be changed too.
> > 
> > 
> > Then fix this first.
> 
> Rafael indicated he would do that,

Yes, and I'm still going to do that. :-)

Thanks,
Rafael
