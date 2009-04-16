Return-Path: <linux-kernel-owner+w=401wt.eu-S1758723AbZDPSAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723AbZDPSAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 14:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757177AbZDPSAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 14:00:42 -0400
Received: from mail.gmx.net ([213.165.64.20]:46037 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756752AbZDPSAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 14:00:41 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18/2HVkEhg/LHgNy2cxLPcwMvdcOdYOTMC9dpK29e
	QHPtQZsjH0hFXE
Subject: Re: [PATCH RFC] ext3 data=guarded v3
From: Mike Galbraith <efault@gmx.de>
To: Chris Mason <chris.mason@oracle.com>
Cc: Jan Kara <jack@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>
In-Reply-To: <1239893771.4346.0.camel@think.oraclecorp.com>
References: <1239816159-6868-1-git-send-email-chris.mason@oracle.com>
	 <1239881953.20254.17.camel@marge.simson.net>
	 <1239893771.4346.0.camel@think.oraclecorp.com>
Content-Type: text/plain
Date: Thu, 16 Apr 2009 20:00:37 +0200
Message-Id: <1239904837.6091.1.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-16 at 10:56 -0400, Chris Mason wrote:
> On Thu, 2009-04-16 at 13:39 +0200, Mike Galbraith wrote:
> > On Wed, 2009-04-15 at 13:22 -0400, Chris Mason wrote:
> > > Hello everyone,
> > 
> > Greetings,
> > 
> > > This passed a longer stress test and generally seems to be working.  I
> > > don't think anyone would recommend it as a default for 2.6.30, but it
> > > may be a good idea to have a review party and decide if it is safe enough
> > > to include so people can experiment with it.
> > 
> > I know you didn't say RFT, but I did some anyway, and found a 100%
> > repeatable corruption scenario wrt git+umount.
> > 
> 
> Well, that's a surprise.  I can trigger it here too, trying to figure
> out how this is different from the fsx and fsstress hammering.  It looks
> like git is just going good old fashioned writes, so I must be losing
> one or two of them.

Yeah, I spent 6 hours doing a lot of this and that, and all was peachy.
This was the only hiccup, and I totally accidentally hit it.

	-Mike

