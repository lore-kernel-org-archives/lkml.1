Return-Path: <linux-kernel-owner+w=401wt.eu-S1758878AbYLPUxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878AbYLPUxu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 15:53:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbYLPUxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 15:53:38 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:34497 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbYLPUxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 15:53:37 -0500
Date: Tue, 16 Dec 2008 20:53:35 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: suspend/resume fails on second attempt in LNXVIDEO:00
Message-ID: <20081216205335.GA14332@srcf.ucam.org>
References: <gi247o$iog$1@ger.gmane.org> <200812161625.37318.rjw@sisk.pl> <gi8jf1$m5f$5@ger.gmane.org> <200812161713.08451.rjw@sisk.pl> <20081216163746.GA9478@srcf.ucam.org> <gi8qoj$m5f$7@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gi8qoj$m5f$7@ger.gmane.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 06:07:15PM +0000, Brian J. Murrell wrote:
> On Tue, 16 Dec 2008 16:37:46 +0000, Matthew Garrett wrote:
> > 
> > I seem to be missing the original message, but: no, s2ram doesn't exist
> > in Ubuntu because pm-utils handles that role.
> 
> Well, that's *their* argument but lots of people think otherwise.  There 
> appears to be no shortage of people for whom pm-utils does NOT work yet 
> s2ram does.  https://bugs.launchpad.net/ubuntu/+source/uswsusp/+bug/134238

The right answer to "This piece of software contains bugs" is not 
"Provide two pieces of software with the same features but different 
bugs". The only real functional difference between the two is that s2ram 
has its own internal whitelist rather than just using the hal entries. 
Suse have normally been good at making sure that they're synced across, 
but if that's not happening you probably want to poke them.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
