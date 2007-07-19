Return-Path: <linux-kernel-owner+w=401wt.eu-S934233AbXGSVlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934233AbXGSVlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 17:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760031AbXGSVl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 17:41:29 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:42956 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957AbXGSVl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 17:41:29 -0400
Date: Thu, 19 Jul 2007 17:41:16 -0400
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       tchicks@us.ibm.com, trevor.highland@gmail.com, pregan@ic.sunysb.edu,
       toml@us.ibm.com, sergeh@us.ibm.com, mike@halcrow.us
Subject: Re: [PATCH 4/8] eCryptfs: Fix Tag 1 parsing code
Message-ID: <20070719214116.GA4041@filer.fsl.cs.sunysb.edu>
References: <20070719212453.GA13821@halcrow.austin.ibm.com> <20070719212801.GE13821@halcrow.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070719212801.GE13821@halcrow.austin.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2007 at 04:28:01PM -0500, Michael Halcrow wrote:
> Fix up the Tag 1 parsing code to handle size limits and boundaries
> more explicitly. Initialize the new auth_tok's flags.
...
> -	if (unlikely((*packet_size) + 3 > max_packet_size)) {
> -		ecryptfs_printk(KERN_ERR, "Packet size exceeds max\n");
> +	if (unlikely(max_packet_size < 12)) {
> +		printk(KERN_ERR "Invalid max packet size; must be >=12\n");

Hardcoded 12?

Josef 'Jeff' Sipek.

-- 
Humans were created by water to transport it upward.
