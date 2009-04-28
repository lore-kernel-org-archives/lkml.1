Return-Path: <linux-kernel-owner+w=401wt.eu-S1762153AbZD1Sho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762153AbZD1Sho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 14:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758662AbZD1ShW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 14:37:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42218 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760659AbZD1ShV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 14:37:21 -0400
Date: Tue, 28 Apr 2009 11:34:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org,
       Doug Thompson <norsk5@yahoo.com>
Subject: Re: [RFC PATCH 00/21] amd64_edac: EDAC module for AMD64
Message-Id: <20090428113410.e0b04f94.akpm@linux-foundation.org>
In-Reply-To: <20090428160612.GB7239@aftab>
References: <1240931173-17477-1-git-send-email-borislav.petkov@amd.com>
	<20090428155852.GA9956@kroah.com>
	<20090428160612.GB7239@aftab>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(cc Doug.  He was omitted from the [0/n] email.  Please be careul about
that)

On Tue, 28 Apr 2009 18:06:12 +0200
Borislav Petkov <borislav.petkov@amd.com> wrote:

> On Tue, Apr 28, 2009 at 08:58:52AM -0700, Greg KH wrote:
> > On Tue, Apr 28, 2009 at 05:05:52PM +0200, Borislav Petkov wrote:
> > > Hi Andrew,
> > > hi Greg,
> > > 
> > > I think you've already heard about this driver, so here is a first
> > > upstream submission request. It is quite sizable but partly the reason
> > > for it is that it handles ECC detection and reporting for all AMD
> > > K8, F10h and F11h families. It also implements DRAM error injection
> > > functionality, failing DIMM module detection and some other fun stuff
> > > found on F10h and later CPUs.
> > > 
> > > We've been doing testing/bugfixing/scrubbing here for some time, have
> > > converted it to using kernel facilities and basically removed some slack
> > > from it like glue code due to it being maintained out-of-tree. Please
> > > take a look and let us know of any objections/comments you might have so
> > > that we could tackle them on time.
> > 
> > At first glance, it looks sane to me.
> > 
> > Want me to put it in my driver tree so it can show up in -next?  Or is
> > there some other tree you want to use?
> 
> -next should be just fine, let the code see some more testing :).

I suspect we will need another iteration because of the rdmsr/wrmsr
thing.

I normally merge EDAC patches via -mm but there will be little overlap
with a new driver such as this and I still haven't got my junk into
linux-next yet.  So whatever.

