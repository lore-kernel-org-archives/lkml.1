Return-Path: <linux-kernel-owner+w=401wt.eu-S933993AbXGSV4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933993AbXGSV4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 17:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756482AbXGSV4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 17:56:07 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:39511 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753915AbXGSV4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 17:56:03 -0400
Date: Thu, 19 Jul 2007 16:53:48 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       tchicks@us.ibm.com, trevor.highland@gmail.com, pregan@ic.sunysb.edu,
       toml@us.ibm.com, sergeh@us.ibm.com, mike@halcrow.us
Subject: Re: [PATCH 4/8] eCryptfs: Fix Tag 1 parsing code
Message-ID: <20070719215347.GA14091@halcrow.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20070719212453.GA13821@halcrow.austin.ibm.com> <20070719212801.GE13821@halcrow.austin.ibm.com> <20070719214116.GA4041@filer.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070719214116.GA4041@filer.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2007 at 05:41:16PM -0400, Josef Sipek wrote:
> On Thu, Jul 19, 2007 at 04:28:01PM -0500, Michael Halcrow wrote:
> > Fix up the Tag 1 parsing code to handle size limits and boundaries
> > more explicitly. Initialize the new auth_tok's flags.
> ...
> > -	if (unlikely((*packet_size) + 3 > max_packet_size)) {
> > -		ecryptfs_printk(KERN_ERR, "Packet size exceeds max\n");
> > +	if (unlikely(max_packet_size < 12)) {
> > +		printk(KERN_ERR "Invalid max packet size; must be >=12\n");
> 
> Hardcoded 12?

It's not so much a magic number if you preserve the comment
immediately above it.
