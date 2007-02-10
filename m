Return-Path: <linux-kernel-owner+w=401wt.eu-S1753065AbXBJEm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065AbXBJEm7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 23:42:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753066AbXBJEm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 23:42:59 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:38999 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064AbXBJEm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 23:42:59 -0500
Subject: Re: NAK new drivers without proper power management?
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070210034210.GB16490@srcf.ucam.org>
References: <1171058269.1484.64.camel@nigel.suspend2.net>
	 <20070210034210.GB16490@srcf.ucam.org>
Content-Type: text/plain
Date: Sat, 10 Feb 2007 15:42:56 +1100
Message-Id: <1171082576.10170.20.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sat, 2007-02-10 at 03:42 +0000, Matthew Garrett wrote:
> On Sat, Feb 10, 2007 at 08:57:49AM +1100, Nigel Cunningham wrote:
> 
> > Can we start to NAK new drivers that don't have proper power management
> > implemented? There really is no excuse for writing a new driver and not
> > putting .suspend and .resume methods in anymore, is there?
> 
> The PCI layer is able to deal with drivers that have no PM methods in 
> the most simple case.

Yeah. I suppose we could use a pm_safe bit flag in struct device_driver
and/or struct pci_driver. I have other things to do right now, but will
seek to understand the relationship between those structs better later.

Regards,

Nigel

