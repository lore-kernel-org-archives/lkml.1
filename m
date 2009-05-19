Return-Path: <linux-kernel-owner+w=401wt.eu-S1754894AbZESRxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbZESRxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 13:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbZESRxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 13:53:30 -0400
Received: from THUNK.ORG ([69.25.196.29]:48530 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681AbZESRx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 13:53:29 -0400
Date: Tue, 19 May 2009 13:53:12 -0400
From: Theodore Tso <tytso@mit.edu>
To: David Watson <kernel-nospam@dbwatson.ukfsn.org>,
       Al Viro <viro@ZenIV.linux.org.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #13232] ext3/4 with synchronous writes gets wedged by
	Postfix
Message-ID: <20090519175312.GC9053@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	David Watson <kernel-nospam@dbwatson.ukfsn.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>
References: <yO1BmxN79sN.A.xAG.8_zDKB@chimera> <pQ9WADCjgyE.A.yJG.DA0DKB@chimera> <20090518132517.GL32019@mit.edu> <20090519171713.GA3354@dbwatson.ukfsn.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090519171713.GA3354@dbwatson.ukfsn.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 19, 2009 at 06:17:13PM +0100, David Watson wrote:
> On Mon 18 May 2009, Theodore Tso wrote:
> > On Sat, May 16, 2009 at 10:06:04PM +0200, Rafael J. Wysocki wrote:
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13232
> > > Subject		: ext3/4 with synchronous writes gets wedged by Postfix
> > > Submitter	: David Watson <kernel-nospam@dbwatson.ukfsn.org>
> > > Date		: 2009-05-03 19:46 (14 days old)
> > 
> > This turned out to be caused by change in the VFS, as documented in
> > the bug report.  Al Viro has a patch, which I've reviewed.
> > 
> > David, would you be able to try testing Al's proposed patch, since you
> > have an easy reproduction case?  Thanks,
> 
> Yes, it fixes the problem for me on 2.6.30-rc6-git3 and 2.6.29.4-rc1.

Thanks, David.

Al, Jan Kara and I have reviewed your patch, and we can add a
Tested-by: from David Watson (assuming David, you don't mind your name
or e-mail address showing up in the Kernel commit logs --- if you want
us to suppress one or both, please let us know).  Given this is a
2.6.28 regression, and this can certainly affect real-life users, I
think we should push your patch to Linus for 2.6.30.  Do you agree?

Regards,

						- Ted
