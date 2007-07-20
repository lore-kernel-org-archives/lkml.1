Return-Path: <linux-kernel-owner+w=401wt.eu-S1763521AbXGTGN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763521AbXGTGN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 02:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754365AbXGTGNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 02:13:20 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:37545 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752937AbXGTGNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 02:13:19 -0400
Date: Fri, 20 Jul 2007 16:13:00 +1000
From: David Chinner <dgc@sgi.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mark Fasheh <mark.fasheh@oracle.com>, dgc@sgi.com, mhalcrow@us.ibm.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] fix some conversion overflows
Message-ID: <20070720061300.GF31489@sgi.com>
References: <20070720054004.GA22099@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070720054004.GA22099@wotan.suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 07:40:04AM +0200, Nick Piggin wrote:
> Fix page index to offset conversion overflows in buffer layer, ecryptfs,
> and ocfs2.
> 
> It would be nice to convert the whole tree to page_offset, but for now
> just fix the bugs.

Yup, that's part of the clean-ups in Christoph Lameter's variable 
order page cache patch set. i.e.:

http://marc.info/?l=linux-kernel&m=118236497117452&w=2

and friends like:

http://marc.info/?l=linux-kernel&m=118236459007960&w=2
http://marc.info/?l=linux-kernel&m=118236495712004&w=2

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
