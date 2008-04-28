Return-Path: <linux-kernel-owner+w=401wt.eu-S936738AbYD1Xwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936738AbYD1Xwt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 19:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755509AbYD1Xwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 19:52:41 -0400
Received: from prod.aconex.com ([203.89.192.138]:48507 "EHLO
	postoffice2.aconex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755012AbYD1Xwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 19:52:40 -0400
X-ASG-Debug-ID: 1209426745-0bfd00070000-xx1T2L
X-Barracuda-URL: http://intranex.aconex.com:8000/cgi-bin/mark.cgi
X-ASG-Orig-Subj: Re: [PATCH] xfs: reduce stack usage in xfs_bmap_btalloc()
Subject: Re: [PATCH] xfs: reduce stack usage in xfs_bmap_btalloc()
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Denys Vlasenko <vda.linux@googlemail.com>, David Chinner <dgc@sgi.com>,
       xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>,
       Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <4815A7A5.9040507@firstfloor.org>
References: <200804261651.02078.vda.linux__2040.04651536724$1209223026$gmane$org@googlemail.com>
	 <87iqy4wfjq.fsf@basil.nowhere.org> <20080426200701.GA10883@infradead.org>
	 <20080426202630.GG17905@one.firstfloor.org>
	 <20080426202323.GA14245@infradead.org>
	 <1209341212.23166.122.camel@edge.scott.net.au>
	 <4815A7A5.9040507@firstfloor.org>
Content-Type: text/plain
Organization: Aconex
Date: Tue, 29 Apr 2008 09:52:33 +1000
Message-Id: <1209426754.23166.160.camel@edge.scott.net.au>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: postoffice.yarra.acx[192.168.3.1]
X-Barracuda-Start-Time: 1209426745
X-Barracuda-Virus-Scanned: by Aconex Staff Email Spam Firewall at aconex.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-28 at 12:32 +0200, Andi Kleen wrote:
> > and
> > its a side-effect of needing to do that (all the code
> > dealing with specifics of ondisk format is shared).
> 
> But does that really need "STATIC"? Seems doubtful to me.

In userspace STATIC is defined to nothing, and the tools
(and/or libxfs) directly call into numerous functions that
are (really) static in the kernel.

cheers.

-- 
Nathan

