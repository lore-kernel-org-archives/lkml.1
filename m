Return-Path: <linux-kernel-owner+w=401wt.eu-S1753863AbZBPTBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbZBPTBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 14:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbZBPTBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 14:01:11 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:44279 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbZBPTBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 14:01:10 -0500
Date: Mon, 16 Feb 2009 19:01:00 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Frans Pop <elendil@planet.nl>
Cc: trenn@suse.de, linux-kernel@vger.kernel.org
Subject: Re: cpuinfo shows wrong MHz value
Message-ID: <20090216190100.GA10627@srcf.ucam.org>
References: <200902142217.51655.jplatte@naasa.net> <loom.20090216T141158-818@post.gmane.org> <20090216165008.GA8249@srcf.ucam.org> <200902161913.16021.trenn@suse.de> <200902161913.16021.trenn@suse.de> <20090216181936.GA9831@srcf.ucam.org> <200902161952.38122.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902161952.38122.elendil@planet.nl>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 07:52:37PM +0100, Frans Pop wrote:
> Matthew Garrett wrote:
> > On Mon, Feb 16, 2009 at 07:13:15PM +0100, Thomas Renninger wrote:
> >> AFAIK p4-clockmode is still not synchronized with ACPI throttling?
> > 
> > It ought to work fine with any systems using MSR-based throttling.
> 
> So what's your take on this particular bug report then Matthew? Is this a 
> regression that should be tracked down and fixed, or is this a case where 
> the user should just not be using the module?

It's a bug and it should be fixed. My recollection is that we've hit 
this kind of thing before - the frequency calculation code is awkward to 
get right on this hardware.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
