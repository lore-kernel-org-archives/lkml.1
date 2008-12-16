Return-Path: <linux-kernel-owner+w=401wt.eu-S1757860AbYLPQiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860AbYLPQiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 11:38:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755806AbYLPQiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 11:38:05 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:40076 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519AbYLPQiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 11:38:03 -0500
Date: Tue, 16 Dec 2008 16:37:46 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Brian J. Murrell" <brian@interlinx.bc.ca>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: suspend/resume fails on second attempt in LNXVIDEO:00
Message-ID: <20081216163746.GA9478@srcf.ucam.org>
References: <gi247o$iog$1@ger.gmane.org> <200812161625.37318.rjw@sisk.pl> <gi8jf1$m5f$5@ger.gmane.org> <200812161713.08451.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812161713.08451.rjw@sisk.pl>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 05:13:08PM +0100, Rafael J. Wysocki wrote:
> On Tuesday, 16 of December 2008, Brian J. Murrell wrote:
> > On Tue, 16 Dec 2008 16:25:37 +0100, Rafael J. Wysocki wrote:
> > 
> > > Because the hal-driven whitelist allows us to match systems in a more
> > > detailed way.  If your system is in the s2ram whitelist already and
> > > works with it, there shouldn't be any difference.
> > 
> > Unfortunately, Ubuntu in their "wisdom" removed s2ram and claim "s2both" 
> > supersedes it in that it does both suspend to disk and suspend to ram and 
> > then suspends, but if your battery dies while suspended you can still 
> > resume from the suspend to disk.

I seem to be missing the original message, but: no, s2ram doesn't exist 
in Ubuntu because pm-utils handles that role.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
