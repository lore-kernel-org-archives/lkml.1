Return-Path: <linux-kernel-owner+w=401wt.eu-S1759050AbXFZWte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759050AbXFZWte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 18:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754906AbXFZWt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 18:49:26 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:54379 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbXFZWtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 18:49:25 -0400
Subject: Re: [PATCH 16/16] fix handling of integer constant expressions
From: Josh Triplett <josht@linux.vnet.ibm.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Josh Triplett <josh@freedesktop.org>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
In-Reply-To: <20070626221040.GI21478@ftp.linux.org.uk>
References: <E1I2N6V-0003g9-8H@ZenIV.linux.org.uk>
	 <20070624174732.GZ21478@ftp.linux.org.uk>
	 <alpine.LFD.0.98.0706241102160.3593@woody.linux-foundation.org>
	 <20070624183547.GA21478@ftp.linux.org.uk>
	 <alpine.LFD.0.98.0706241203530.3593@woody.linux-foundation.org>
	 <1a25667a20e43a072f733a3ec2b8e79d@kernel.crashing.org>
	 <20070624203837.GE21478@ftp.linux.org.uk>
	 <467F531A.3030702@freedesktop.org>
	 <20070626221040.GI21478@ftp.linux.org.uk>
Content-Type: text/plain
Date: Tue, 26 Jun 2007 15:49:23 -0700
Message-Id: <1182898163.3191.7.camel@josh-work.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-26 at 23:10 +0100, Al Viro wrote:
> On Sun, Jun 24, 2007 at 10:31:06PM -0700, Josh Triplett wrote:
> > Al Viro wrote:
> > > Joy.  OK, folks, disregard 16/16 in the current form; everything prior
> > > to it stands on its own.
> > 
> > Acknowledged.  The rest of the patches look good to me, so I'll merge 1-15
> > soon, and ignore 16.
> 
> OK, here's the replacement.  First the handling of __builtin_offsetof()
> (below in this mail), then integer constant expressions (in followup).
> They can be pulled from
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/sparse.git/ integer-constant

Both patches looked good to me in review, and neither changes the
validation output.  Merged.  Thanks!

- Josh Triplett


