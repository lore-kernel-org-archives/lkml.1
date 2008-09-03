Return-Path: <linux-kernel-owner+w=401wt.eu-S1755497AbYICOpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbYICOpz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 10:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732AbYICOpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 10:45:46 -0400
Received: from mail.suse.de ([195.135.220.2]:60006 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbYICOpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 10:45:45 -0400
Date: Wed, 3 Sep 2008 16:45:41 +0200
From: Holger Macht <hmacht@suse.de>
To: Steven King <sfking@fdwdc.com>
Cc: Tomas Carnecky <tom@dbservice.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Zhang Rui <rui.zhang@intel.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net
Subject: Re: 2.6.26.[1-3] + x61 tablet + x6ultrabase: no resume
	after?undocking
Message-ID: <20080903144541.GA10978@homac>
Mail-Followup-To: Steven King <sfking@fdwdc.com>,
	Tomas Carnecky <tom@dbservice.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Zhang Rui <rui.zhang@intel.com>, linux-kernel@vger.kernel.org,
	linux-acpi@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net
References: <200808301535.22419.sfking@fdwdc.com> <20080901112816.GA21970@khazad-dum.debian.net> <48BBDD2C.5020804@dbservice.com> <200809011205.05253.sfking@fdwdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809011205.05253.sfking@fdwdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 01. Sep - 12:05:04, Steven King wrote:
> On Monday 01 September 2008 5:16:44 Tomas Carnecky wrote:
> 
> > I just tested suspend/resume with the CDROM drive removed (an empty
> > bay). Suspend/resume now works just fine, regardless how I dock/undock
> > the laptop.
> 
> I'm seeing the exact same things as Tom.  Also, in my dmesg I see:
> 
> ACPI: \_SB_.PCI0.IDE0.PRIM.MSTR: found ejectable bay
> ACPI: \_SB_.PCI0.IDE0.PRIM.MSTR: Adding notify handler
> ACPI: Error installing bay notify handler
> 
> is this significant?

No, it's not. Bay driver is obsolete with 2.6.26's libata hotplug code.

Regards,
	Holger
