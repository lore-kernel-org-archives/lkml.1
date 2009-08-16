Return-Path: <linux-kernel-owner+w=401wt.eu-S1755478AbZHPQEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbZHPQEN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 12:04:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754882AbZHPQEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 12:04:12 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:50962 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbZHPQEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 12:04:12 -0400
Date: Sun, 16 Aug 2009 17:04:06 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-usb@vger.kernel.org,
       linux-pci@vger.kernel.org, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [RFC] PCI: Runtime power management
Message-ID: <20090816160406.GA10163@srcf.ucam.org>
References: <200908152321.53283.rjw@sisk.pl> <Pine.LNX.4.44L0.0908161151020.6522-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0908161151020.6522-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 16, 2009 at 11:57:53AM -0400, Alan Stern wrote:
> On Sat, 15 Aug 2009, Rafael J. Wysocki wrote:
> 
> > > Why would you ever want runtime_wakeup to be false unless 
> > > runtime_forbidden is true? Surely the point of runtime power management 
> > > is to be transparent to the user, in which case remote wakeup is 
> > > required?
> 
> Matthew, what makes you think remote wakeup is required?  Lots of
> power-manageable devices don't support it at all (consider disk drives
> or display screens).

Sorry, I meant in cases where remote wakeup is a sensible concept. For 
things like storage there's obviously no reason to require it, but for 
something like USB the absence of remote wakeup would effectively break 
the driver for most users.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
