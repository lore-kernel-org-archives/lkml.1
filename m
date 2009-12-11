Return-Path: <linux-kernel-owner+w=401wt.eu-S1752962AbZLKQuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962AbZLKQuH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 11:50:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbZLKQuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 11:50:05 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:43557 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbZLKQuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 11:50:04 -0500
Date: Fri, 11 Dec 2009 16:50:04 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [lm-sensors] [PATCH] hwmon: Add driver for intel PCI thermal
	subsystem
Message-ID: <20091211165004.GA2156@srcf.ucam.org>
References: <1260546750-6206-1-git-send-email-mjg@redhat.com> <68676e00912110828q26e511edt52546f09490c9431@mail.gmail.com> <20091211163328.GA1596@srcf.ucam.org> <68676e00912110836p278985cfv3d052e16a22916b1@mail.gmail.com> <20091211163822.GA1869@srcf.ucam.org> <68676e00912110847o3594931etf6e045340043e2c6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68676e00912110847o3594931etf6e045340043e2c6@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 05:47:29PM +0100, Luca Tettamanti wrote:

> Sorry, I think we're not understanding each other :)
> Does the PCH samples the values directly from the probes? Or is it an
> interface for the real monitoring chip (most likely the superio chip)?
> In the latter case it might be possible to access directly the
> monitoring hardware using another driver (e.g. w83627ehf, lm80, etc.),
> thus racing against the PCI driver.
> Did I make myself clear?

I don't think there's any other chip. On systems using external chips, 
this PCI device will simply be disabled by the BIOS before the OS boots.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
