Return-Path: <linux-kernel-owner+w=401wt.eu-S1756121AbZFHPMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121AbZFHPMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 11:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755889AbZFHPMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 11:12:03 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41962 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756748AbZFHPMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 11:12:01 -0400
Date: Mon, 8 Jun 2009 16:11:56 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Oliver Neukum <oliver@neukum.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Magnus Damm <magnus.damm@gmail.com>
Subject: Re: Run-time PM idea (was: Re: [linux-pm] [RFC][PATCH 0/2] PM:
	Rearrange core suspend code)
Message-ID: <20090608151156.GA17805@srcf.ucam.org>
References: <Pine.LNX.4.44L0.0906071651060.25203-100000@netrider.rowland.org> <20090608131159.GA15100@srcf.ucam.org> <20090608132235.GC13214@elte.hu> <200906081539.20459.oliver@neukum.org> <20090608142154.GD14234@elte.hu> <20090608143023.GA16752@srcf.ucam.org> <20090608150603.GB20905@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090608150603.GB20905@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 05:06:03PM +0200, Ingo Molnar wrote:

> But if you think that tracking the usage state of the hardware is 
> 'complexity', then you very much dont know what you are talking 
> about. The main task of the kernel is to track hardware usage and to 
> abstract away the fact that the same hardware is used by multiple 
> tasks, and to do it safely. It's what the kernel does all day.

What I'm saying is that you don't *know* what the usage state of the 
hardware is, and in many cases you can't know. A given user may be happy 
to sacrifice their SATA hotplug support. Another with identical hardware 
may not. A given network application may be mission critical and 
intolerant of the network interface being shut down. The same 
application in a different context may not. We'd need to provide a 
bewildering array of interfaces to distinguish between these situations, 
and we'd be unable to turn on autosuspend until the entirity of 
userspace had been ported to them.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
