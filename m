Return-Path: <linux-kernel-owner+w=401wt.eu-S1757956AbYFIADu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956AbYFIADu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 20:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754574AbYFIADn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 20:03:43 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:56925 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531AbYFIADn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 20:03:43 -0400
Date: Mon, 9 Jun 2008 01:03:39 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: rpurdie@rpsys.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add backlight driver for Nvidia-based Apple Macbook Pros
Message-ID: <20080609000339.GA28756@srcf.ucam.org>
References: <20080607025436.GB24254@srcf.ucam.org> <20080608183255.GB3580@tango.0pointer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080608183255.GB3580@tango.0pointer.de>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 08, 2008 at 08:32:55PM +0200, Lennart Poettering wrote:

> It should be pretty easy to figure out the right string for
> DMI autoloading. Just do a cat /sys/class/dmi/id/modalias and replace the
> part of the string you consider not very useful for identifying the
> machine with (dates, version numbers, empty strings, 0123456
> rubbish data, ...) with an asterisk.

Ah! Spaces are removed in the sysfs interface. That would explain the 
problem. I'll send a new version.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
