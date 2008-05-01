Return-Path: <linux-kernel-owner+w=401wt.eu-S1760579AbYEAMyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760579AbYEAMyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 08:54:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756472AbYEAMyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 08:54:00 -0400
Received: from mjg.x.mythic-beasts.com ([93.93.128.6]:45076 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754289AbYEAMyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 08:54:00 -0400
Date: Thu, 1 May 2008 13:53:48 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Len Brown <lenb@kernel.org>
Cc: Gabriel C <nix.or.die@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, pavel@suse.cz,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Message-ID: <20080501125348.GA19922@srcf.ucam.org>
References: <4818D9AB.3040402@googlemail.com> <200805010157.58607.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805010157.58607.lenb@kernel.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: Some sort corruption of my Thermal Subsystem after suspend to ram
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 01:57:58AM -0400, Len Brown wrote:

> I'm not aware of a native Linux device driver that talks to this device
> (nor can I think of a useful purpose for such a driver)
> So it seems what is in play here is any BIOS code that talks to this device,
> and Linux's standard PCI config space restore.

Perhaps we should be more aggressive about restoring PCI config space if 
there's no driver bound to a device. The alternative in this case would 
seem to be to write a driver for this device that does nothing other 
than handle suspend/resume.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
