Return-Path: <linux-kernel-owner+w=401wt.eu-S1753620AbZCFKWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620AbZCFKWF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 05:22:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbZCFKVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 05:21:53 -0500
Received: from batfish.pepperfish.net ([87.237.62.180]:35731 "EHLO
	flounder.pepperfish.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750880AbZCFKVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 05:21:52 -0500
Subject: Re: [PATCH] toshiba_acpi: Add full hotkey support
From: Daniel Silverstone <dsilvers@simtec.co.uk>
Reply-To: dsilvers@simtec.co.uk
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Richard Hughes <hughsient@gmail.com>, linux-acpi@vger.kernel.org,
       toshiba_acpi@memebeam.org, linux-kernel@vger.kernel.org,
       len.brown@intel.com
In-Reply-To: <20090306101533.GA6408@srcf.ucam.org>
References: <20090306003941.GA32403@srcf.ucam.org>
	 <20090306005234.GA32539@srcf.ucam.org>
	 <1236330536.12838.2.camel@hughsie-work.lan>
	 <1236332843.19146.4.camel@petitemort> <20090306095623.GA6014@srcf.ucam.org>
	 <1236333861.19146.9.camel@petitemort> <20090306100951.GA6268@srcf.ucam.org>
	 <1236334376.19146.11.camel@petitemort>
	 <20090306101533.GA6408@srcf.ucam.org>
Content-Type: text/plain
Organization: Simtec Electronics
Date: Fri, 06 Mar 2009 10:21:49 +0000
Message-Id: <1236334909.19146.16.camel@petitemort>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-06 at 10:15 +0000, Matthew Garrett wrote:
> > I see. One other thing occurred to me. Is there any way for Hal to know
> > that the notify stuff is in place and thus doesn't need to
> > poll /proc/acpi/toshiba/keys? Otherwise it's going to poll it anyway
> > which fails to remove the periodic wakeups.
> No. Distributions should build without --enable-toshiba if they ship a 
> kernel with this functionaliy.

This only makes sense if all the rest of /proc/acpi/toshiba/* is now
implemented in proper modern kernel facilities. I noticed rfkill
switches (although I'll have to see if another is needed for the HSDPA
modems in modern laptops) and a proper brightness control. I assume
xrandr does what video did, which just leaves the fan control.

D.

-- 
Daniel Silverstone                              http://www.simtec.co.uk/
PGP mail accepted and encouraged.            Key Id: 2BC8 4016 2068 7895


