Return-Path: <linux-kernel-owner+w=401wt.eu-S1764248AbXLTWhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764248AbXLTWhq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 17:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755729AbXLTWhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 17:37:31 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:53986 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbXLTWha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 17:37:30 -0500
Date: Thu, 20 Dec 2007 15:37:28 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Mark Lord <liml@rtr.ca>, Andrew Morton <akpm@linux-foundation.org>,
       James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com,
       lkml@rtr.ca, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] fix page_alloc for larger I/O segments (improved)
Message-ID: <20071220223728.GM29690@parisc-linux.org>
References: <20071213142935.47ff19d9.akpm@linux-foundation.org> <4761B32A.3070201@rtr.ca> <4761BCB4.1060601@rtr.ca> <4761C8E4.2010900@rtr.ca> <4761CE88.9070406@rtr.ca> <20071213163726.3bb601fa.akpm@linux-foundation.org> <4761D160.7060603@rtr.ca> <4761D279.6050500@rtr.ca> <20071214174236.GA28613@csn.ul.ie> <20071214181339.GW26334@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071214181339.GW26334@parisc-linux.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2007 at 11:13:40AM -0700, Matthew Wilcox wrote:
> I'll send it to our DB team to see if this improves our numbers at all.

It does, by approximately 0.67%.  This is about double the margin of
error, and a significant improvement.  Thanks!

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
