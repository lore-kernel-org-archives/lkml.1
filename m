Return-Path: <linux-kernel-owner+w=401wt.eu-S935599AbXJPTyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935599AbXJPTyp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 15:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765685AbXJPTyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 15:54:36 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:45496 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763909AbXJPTyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 15:54:35 -0400
Date: Tue, 16 Oct 2007 13:54:33 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: david@lang.hm
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Rob Landley <rob@landley.net>, David Newall <david@davidnewall.com>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Nick Piggin <piggin@cyberone.com.au>
Subject: Re: What still uses the block layer?
Message-ID: <20071016195432.GA31306@parisc-linux.org>
References: <200710112011.22000.rob@landley.net> <200710141836.55211.rob@landley.net> <4712FE33.3000400@s5r6.in-berlin.de> <200710150426.04924.rob@landley.net> <20071015160800.GA324@parisc-linux.org> <47139F15.7050702@s5r6.in-berlin.de> <Pine.LNX.4.64.0710151954550.3949@asgard.lang.hm> <20071016111911.30a18e12@the-village.bc.nu> <Pine.LNX.4.64.0710161238140.6995@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710161238140.6995@asgard.lang.hm>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 12:54:58PM -0700, david@lang.hm wrote:
> On Tue, 16 Oct 2007, Alan Cox wrote:
> >I wouldn't try dividing those by pata v sata. You'll cause all sorts of
> >problems in the process because of PATA-SATA and SATA-PATA bridges.
> 
> if you use a PATA-SATA bridge (IDE drive SATA controller), it would look 
> to the system like a SATA drive and be addressed and enumerated as SATA.

But you don't know where the bridge is.  It might be on the drive's
board, it might be an explicit enclosure, or it might be on the
motherboard.  Each of those scenarios is going to have a different user
expectation.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
