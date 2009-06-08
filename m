Return-Path: <linux-kernel-owner+w=401wt.eu-S1753565AbZFHDHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbZFHDHw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 23:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbZFHDHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 23:07:44 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:49302 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbZFHDHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 23:07:43 -0400
Date: Mon, 8 Jun 2009 04:07:32 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: alan-jenkins@tuffmail.co.uk, Pekka Enberg <penberg@cs.helsinki.fi>,
       Corentin Chary <corentin.chary@gmail.com>,
       acpi4asus-user@lists.sourceforge.net, len.brown@intel.com,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       Darren Salt <linux@youmustbejoking.demon.co.uk>
Subject: Re: [PATCH] eeepc-laptop: enable camera by default
Message-ID: <20090608030732.GA7018@srcf.ucam.org>
References: <20090607232856.GA1805@srcf.ucam.org> <Pine.LNX.4.44L0.0906072256190.28801-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0906072256190.28801-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 07, 2009 at 11:03:48PM -0400, Alan Stern wrote:

> There's no mechanism for this.  It many environments it couldn't work,
> because the decision about whether to enable autosuspend is made when
> the device is first created (i.e., when the creation uevent is
> received), whereas driver binding doesn't occur until later.

There's a lot of power management situations where you don't end up with 
the optimal power configuration until a driver's bound. It's certainly 
possible to do this in userspace, but if we know that the hardware 
supported by a given driver will always work then it seems reasonable to 
have it whitelist autosuspend on that device.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
