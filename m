Return-Path: <linux-kernel-owner+w=401wt.eu-S1755050AbZCFJ4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050AbZCFJ4o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 04:56:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751010AbZCFJ4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 04:56:32 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:58006 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbZCFJ4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 04:56:31 -0500
Date: Fri, 6 Mar 2009 09:56:23 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Daniel Silverstone <dsilvers@simtec.co.uk>
Cc: Richard Hughes <hughsient@gmail.com>, linux-acpi@vger.kernel.org,
       toshiba_acpi@memebeam.org, linux-kernel@vger.kernel.org,
       len.brown@intel.com
Subject: Re: [PATCH] toshiba_acpi: Add full hotkey support
Message-ID: <20090306095623.GA6014@srcf.ucam.org>
References: <20090306003941.GA32403@srcf.ucam.org> <20090306005234.GA32539@srcf.ucam.org> <1236330536.12838.2.camel@hughsie-work.lan> <1236332843.19146.4.camel@petitemort>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236332843.19146.4.camel@petitemort>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 09:47:23AM +0000, Daniel Silverstone wrote:

> Have you looked at whether or not this method functions on more than the
> one laptop? Toshiba are notoriously good at getting their own interfaces
> wrong from one laptop to another.

It's present on every Toshiba DSDT I have that has a VALD/VALZ method.

> In addition, the fn+whatever keymaps are often different between 
> laptops, especially for things like the WWW or MAIL buttons. 
> Presumably if the hotkeys fail to activate then the normal 
> /proc/acpi/toshiba/keys thing will continue?

Yes, it'll be as functional as it was previously. They can be remapped 
on machines that have a different keymap.
 
> How will it interact with software stacks like HAL when the lock button
> is pressed?

I don't really understand the question?
-- 
Matthew Garrett | mjg59@srcf.ucam.org
