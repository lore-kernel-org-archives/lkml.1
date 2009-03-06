Return-Path: <linux-kernel-owner+w=401wt.eu-S1754683AbZCFJrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683AbZCFJrm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 04:47:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbZCFJra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 04:47:30 -0500
Received: from batfish.pepperfish.net ([87.237.62.180]:54039 "EHLO
	flounder.pepperfish.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750865AbZCFJr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 04:47:28 -0500
Subject: Re: [PATCH] toshiba_acpi: Add full hotkey support
From: Daniel Silverstone <dsilvers@simtec.co.uk>
Reply-To: dsilvers@simtec.co.uk
To: Richard Hughes <hughsient@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-acpi@vger.kernel.org,
       toshiba_acpi@memebeam.org, linux-kernel@vger.kernel.org,
       len.brown@intel.com
In-Reply-To: <1236330536.12838.2.camel@hughsie-work.lan>
References: <20090306003941.GA32403@srcf.ucam.org>
	 <20090306005234.GA32539@srcf.ucam.org>
	 <1236330536.12838.2.camel@hughsie-work.lan>
Content-Type: text/plain
Organization: Simtec Electronics
Date: Fri, 06 Mar 2009 09:47:23 +0000
Message-Id: <1236332843.19146.4.camel@petitemort>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-06 at 09:08 +0000, Richard Hughes wrote:
> On Fri, 2009-03-06 at 00:52 +0000, Matthew Garrett wrote:
> > Calling the ENAB method on Toshiba laptops results in notifications 
> > being sent when laptop hotkeys are pressed. This patch simply calls that 
> > method and sets up an input device if it's successful.
> Great news - no polling!

No polling is definitely a good thing.

> Definitely +1 from me.

I'll be a touch less gung-ho than Richard though.

Have you looked at whether or not this method functions on more than the
one laptop? Toshiba are notoriously good at getting their own interfaces
wrong from one laptop to another. In addition, the fn+whatever keymaps
are often different between laptops, especially for things like the WWW
or MAIL buttons. Presumably if the hotkeys fail to activate then the
normal /proc/acpi/toshiba/keys thing will continue?

How will it interact with software stacks like HAL when the lock button
is pressed?

The patch itself looks clean and nice, I'm just concerned about its
behaviour from laptop-to-laptop. Particularly the key-map thing.

D.

-- 
Daniel Silverstone                              http://www.simtec.co.uk/
PGP mail accepted and encouraged.            Key Id: 2BC8 4016 2068 7895


