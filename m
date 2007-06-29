Return-Path: <linux-kernel-owner+w=401wt.eu-S932710AbXF2CJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710AbXF2CJQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 22:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765082AbXF2CJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 22:09:00 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:36193 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765014AbXF2CI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 22:08:59 -0400
Date: Fri, 29 Jun 2007 12:08:33 +1000
From: David Chinner <dgc@sgi.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: Nick Piggin <npiggin@suse.de>, David Chinner <dgc@sgi.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC] fsblock
Message-ID: <20070629020833.GJ31489@sgi.com>
References: <20070624014528.GA17609@wotan.suse.de> <20070626030640.GM989688@sgi.com> <46808E1F.1000509@yahoo.com.au> <20070626092309.GF31489@sgi.com> <20070626123449.GM14224@think.oraclecorp.com> <20070627053245.GA6033@wotan.suse.de> <20070627115056.GW14224@think.oraclecorp.com> <20070627223548.GS989688@sgi.com> <20070628024443.GB6038@wotan.suse.de> <20070628122031.GF5313@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070628122031.GF5313@think.oraclecorp.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2007 at 08:20:31AM -0400, Chris Mason wrote:
> On Thu, Jun 28, 2007 at 04:44:43AM +0200, Nick Piggin wrote:
> > That's true but I don't think an extent data structure means we can
> > become too far divorced from the pagecache or the native block size
> > -- what will end up happening is that often we'll need "stuff" to map
> > between all those as well, even if it is only at IO-time.
> 
> I think the fundamental difference is that fsblock still does:
> mapping_info = page->something, where something is attached on a per
> page basis.  What we really want is mapping_info = lookup_mapping(page),

lookup_block_mapping(page).... ;)

But yes, that is the essence of what I was saying. Thanks for
describing it so concisely, Chris.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
