Return-Path: <linux-kernel-owner+w=401wt.eu-S1758297AbXEVWtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758297AbXEVWtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 18:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756366AbXEVWtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 18:49:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756323AbXEVWtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 18:49:09 -0400
Date: Tue, 22 May 2007 18:49:00 -0400
From: Dave Jones <davej@redhat.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Christoph Hellwig <hch@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, rdunlap@xenotime.net
Subject: Re: RFC: Schedule EFS for removal.
Message-ID: <20070522224900.GE22628@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Willy Tarreau <w@1wt.eu>,
	Christoph Hellwig <hch@infradead.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>, rdunlap@xenotime.net
References: <20070521144618.GA6914@redhat.com> <20070521150242.GA25146@infradead.org> <20070521150937.GB6957@redhat.com> <20070521151209.GA25744@infradead.org> <20070521152050.GC6957@redhat.com> <20070521154613.GA27027@infradead.org> <20070521171109.GC9653@redhat.com> <20070522210152.GM943@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070522210152.GM943@1wt.eu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2007 at 11:01:54PM +0200, Willy Tarreau wrote:

 > >  > > "Under 2.4.21, it doesnt do this."
 > >  > 
 > >  > Randy mentioned in bugzilla that 2.4.22 didn't work either, so I'd
 > >  > be very surprised if 2.4.21 works.
 > > 
 > > good point.  I don't see anything obvious in 2.4.22 that would have
 > > caused a regression, so this sounds suspect.
 > > I'll close the bugzilla out based on your comments, thanks for looking at it.
 > 
 > In my experience, often when people speak about 2.4.21 (which is quite old),
 > they in fact refer to an RHEL3 kernel, which has a "few" addon patches :-)
 > While I don't think that anything related to EFS might be changed in RHEL,
 > may it be possible that it works as a side effect of a patch in this
 > kernel ?
 > 
 > That's just pure guess anyway.

not unless it's a recompiled version.  As shipped, RHEL3 has..

# CONFIG_EFS_FS is not set

	Dave

-- 
http://www.codemonkey.org.uk
