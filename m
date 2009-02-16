Return-Path: <linux-kernel-owner+w=401wt.eu-S1752666AbZBPSN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbZBPSN1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 13:13:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750888AbZBPSNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 13:13:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:56484 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbZBPSNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 13:13:18 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: cpuinfo shows wrong MHz value
Date: Mon, 16 Feb 2009 19:13:15 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27.13-HEAD_20090130075504_71baee03-default; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <200902142217.51655.jplatte@naasa.net> <loom.20090216T141158-818@post.gmane.org> <20090216165008.GA8249@srcf.ucam.org>
In-Reply-To: <20090216165008.GA8249@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902161913.16021.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 February 2009 17:50:08 Matthew Garrett wrote:
> On Mon, Feb 16, 2009 at 02:19:50PM +0000, Thomas Renninger wrote:
> 
> > There should be a message when this driver is loaded like:
> > "This driver is broken. Don't use it, don't complain."
> 
> Please don't. It's perfectly valid (if dumb) for machines to depend on 
> the CPU for passive cooling even if they don't expose any P or T states.
No it's not valid. If the BIOS does not export these, it could be for
a reason.

> In that case p4-clockmod is the only code that can manage it. The 
> removal of the user-visible cpufreq interface should be a strong enough 
> hint that it's not intended for speed control.
AFAIK p4-clockmode is still not synchronized with ACPI throttling?
Thus this driver will destroy a valid machine setup where the BIOS exports
throttling states via ACPI.
The driver is broken (and rather useless) and all the complaints about it
get annoying.

I wonder how dangerous it even is. If thermal management on a P4 is 
properly implemented via "BIOS throws high temperature MCE and throttles 
the CPU itself", could the p4_clockmode driver override the BIOS/HW
settings and still run unthrottled? Danger!

Anyway, I better do not answer on p4_clockmode complaints anymore and
simply delete them, it's just a waste of time.

     Thomas
