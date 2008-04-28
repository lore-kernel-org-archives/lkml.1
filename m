Return-Path: <linux-kernel-owner+w=401wt.eu-S1763336AbYD1AWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763336AbYD1AWk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 20:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbYD1AWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 20:22:33 -0400
Received: from prod.aconex.com ([203.89.192.138]:44266 "EHLO
	postoffice2.aconex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751007AbYD1AWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 20:22:32 -0400
X-Greylist: delayed 935 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Apr 2008 20:22:32 EDT
X-ASG-Debug-ID: 1209341204-6939002a0000-xx1T2L
X-Barracuda-URL: http://intranex.aconex.com:8000/cgi-bin/mark.cgi
X-ASG-Orig-Subj: Re: [PATCH] xfs: reduce stack usage in xfs_bmap_btalloc()
Subject: Re: [PATCH] xfs: reduce stack usage in xfs_bmap_btalloc()
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Denys Vlasenko <vda.linux@googlemail.com>, David Chinner <dgc@sgi.com>,
       xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>,
       Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080426202323.GA14245@infradead.org>
References: <200804261651.02078.vda.linux__2040.04651536724$1209223026$gmane$org@googlemail.com>
	 <87iqy4wfjq.fsf@basil.nowhere.org> <20080426200701.GA10883@infradead.org>
	 <20080426202630.GG17905@one.firstfloor.org>
	 <20080426202323.GA14245@infradead.org>
Content-Type: text/plain
Organization: Aconex
Date: Mon, 28 Apr 2008 10:06:51 +1000
Message-Id: <1209341212.23166.122.camel@edge.scott.net.au>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: postoffice.yarra.acx[192.168.3.1]
X-Barracuda-Start-Time: 1209341204
X-Barracuda-Virus-Scanned: by Aconex Staff Email Spam Firewall at aconex.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-04-26 at 16:23 -0400, Christoph Hellwig wrote:
> 
> 
> 
> 
>                              Date: 
> Sat, 26 Apr 2008 16:23:23 -0400
> (Sun, 06:23 EST)
> 
> 
> On Sat, Apr 26, 2008 at 10:26:30PM +0200, Andi Kleen wrote:
> > > STATIC as defined by xfs already does this..
> > 
> > Weird. Unexpected. Different from everyone else. Is this some
> exercise in 
> > obfuscation?
> 
> The whole STATIC thing is weird to start with..
> 

Having to compile chunks of XFS code in both kernel and
userspace is also wierd (relative to other drivers), and
its a side-effect of needing to do that (all the code
dealing with specifics of ondisk format is shared).

cheers.

-- 
Nathan

