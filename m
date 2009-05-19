Return-Path: <linux-kernel-owner+w=401wt.eu-S1755659AbZESQdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbZESQdp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 12:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbZESQdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 12:33:38 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:43769 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbZESQdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 12:33:37 -0400
Date: Tue, 19 May 2009 17:33:33 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Mario Limonciello <mario_limonciello@dell.com>
Cc: Oliver Neukum <oliver@neukum.org>, Marcel Holtmann <marcel@holtmann.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Explicitly disable BT radio using rfkill interface on
	suspend
Message-ID: <20090519163333.GA17189@srcf.ucam.org>
References: <4A11C126.1000704@dell.com> <1242710064.3147.4.camel@localhost.localdomain> <20090519090610.GA29967@srcf.ucam.org> <200905191447.34000.oliver@neukum.org> <20090519125853.GA12483@srcf.ucam.org> <4A12DEA8.4060305@dell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A12DEA8.4060305@dell.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 19, 2009 at 11:30:32AM -0500, Mario Limonciello wrote:
> Hi Guys:
> 
> Matthew Garrett wrote:
> > On Tue, May 19, 2009 at 02:47:33PM +0200, Oliver Neukum wrote:
> >   
> >
> > It doesn't seem to for Mario, otherwise this patch wouldn't change 
> > anything.
> >
> >   
> During S3, when power gets cut, the device is reset and the radio
> logical device no longer shows up.  At no point do either of the USB
> keyboard/mouse devices stop showing up on the bus.  Henceforth, there is
> no event for udev to trigger from when a mouse or keyboard gets
> added/removed.

I thought all USB devices got reenumerated on resume?
-- 
Matthew Garrett | mjg59@srcf.ucam.org
