Return-Path: <linux-kernel-owner+w=401wt.eu-S1755016AbXFPLUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016AbXFPLUU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 07:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbXFPLUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 07:20:09 -0400
Received: from saeurebad.de ([85.214.36.134]:55487 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547AbXFPLUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 07:20:08 -0400
Date: Sat, 16 Jun 2007 13:20:04 +0200
From: Johannes Weiner <hannes-kernel@saeurebad.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Versioning file system
Message-ID: <20070616112004.GA22307@saeurebad.de>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <46731169.2090002@hawkeye.stone.uk.eu.org> <4673194D.4090500@intel.com> <Pine.LNX.4.64.0706151558180.27993@blackbox.fnordora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706151558180.27993@blackbox.fnordora.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jun 15, 2007 at 04:01:14PM -0700, alan wrote:
> On Fri, 15 Jun 2007, Kok, Auke wrote:
> ><snip>
> >
> >have you looked into ext3cow? it allows you to take snapshots of the 
> >entire ext3 fs at a single point, and rollback / extract snapshots at any 
> >time later. This may be sufficient for you and the implementation seems to 
> >be rather stable already.
> 
> As long as there is only one person using the file system.  Rolling back 
> the entire filesystem may work well for you, but screw up something else 
> someone else is doing.
> 
> And what kind of rights do you have to assign to the user to do that level 
> of snapshot and rollback?  You have to assume that there are more than one 
> user and that they have less than root privileges.

Perhaps BTRFS might be of interest where you can have a subvolume for every
user: http://lkml.org/lkml/2007/6/12/242

		Hannes
