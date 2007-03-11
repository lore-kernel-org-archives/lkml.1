Return-Path: <linux-kernel-owner+w=401wt.eu-S933214AbXCKGUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933214AbXCKGUF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 01:20:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933217AbXCKGUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 01:20:04 -0500
Received: from mail32.syd.optusnet.com.au ([211.29.132.63]:37261 "EHLO
	mail32.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933214AbXCKGUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 01:20:02 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: RSDL-mm 0.28
Date: Sun, 11 Mar 2007 17:19:38 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck@vds.kolivas.org
References: <20070311013506.GD10459@waste.org> <20070311040132.GS10394@waste.org> <20070311040305.GT10394@waste.org>
In-Reply-To: <20070311040305.GT10394@waste.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703111719.38514.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 March 2007 15:03, Matt Mackall wrote:
> On Sat, Mar 10, 2007 at 10:01:32PM -0600, Matt Mackall wrote:
> > On Sun, Mar 11, 2007 at 01:28:22PM +1100, Con Kolivas wrote:
> > > Ok I don't think there's any actual accounting problem here per se
> > > (although I did just recently post a bugfix for rsdl however I think
> > > that's unrelated). What I think is going on in the ccache testcase is
> > > that all the work is being offloaded to kernel threads reading/writing
> > > to/from the filesystem and the make is not getting any actual cpu
> > > time.
> >
> > I don't see significant system time while this is happening.
>
> Also, it's running pretty much entirely out of page cache so there
> wouldn't be a whole lot for kernel threads to do.

Well I can't reproduce that behaviour here at all whether from disk or the 
pagecache with ccache, so I'm not entirely sure what's different at your end. 
However both you and the other person reporting bad behaviour were using ATI 
drivers. That's about the only commonality? I wonder if they do need to 
yield... somewhat instead of not at all.

-- 
-ck
