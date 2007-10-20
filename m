Return-Path: <linux-kernel-owner+w=401wt.eu-S1765095AbXJTMTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765095AbXJTMTP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 08:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000AbXJTMS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 08:18:58 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:52610 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753938AbXJTMS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 08:18:57 -0400
Subject: Re: oops in lbmIODone, fails to boot [Re: 2.6.23-mm1]
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mattia Dongili <malattia@linux.it>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <20071019223440.3bf845ef.akpm@linux-foundation.org>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
	 <20071020045753.GA4660@inferi.kami.home>
	 <20071019223440.3bf845ef.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sat, 20 Oct 2007 07:18:26 -0500
Message-Id: <1192882706.9464.1.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-19 at 22:34 -0700, Andrew Morton wrote:
> On Sat, 20 Oct 2007 13:57:54 +0900 Mattia Dongili <malattia@linux.it> wrote:
> 
> > On Thu, Oct 11, 2007 at 09:31:26PM -0700, Andrew Morton wrote:
> > > 
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23/2.6.23-mm1/
> > 
> > Hey there!!
> > fails to boot here with this friendly oops:
> > http://oioio.altervista.org/linux/dsc01702.jpg
> > 
> > .config: http://oioio.altervista.org/linux/config-2.6.23-mm1-1
> > 
> > 2.6.23-rc8-mm2 booted ok but had other problems I haven't reported yet
> > (no s2ram with mysql running and some net WARNING).
> > Let's see if .23-mm1 still has those first.
> > 
> > I'm adding Cc: linux-scsi
> > 
> > PS: I'll hardly be able to bisect in the next days... :P
> 
> That looks like a Jens and Dave production to me.

Yes, and it's been fixed:
http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=8d8fe64237646fdd2c2de2722ec4189a5999119d

See also: http://lkml.org/lkml/2007/10/13/174

Thanks,
Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

