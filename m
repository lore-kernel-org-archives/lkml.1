Return-Path: <linux-kernel-owner+w=401wt.eu-S1754659AbYJFGXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbYJFGXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 02:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752690AbYJFGXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 02:23:09 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:35687 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbYJFGXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 02:23:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JozGSh4UyIhpYUqHxnrSsTNxjgcjlVFxQPoqpienuqtPTnOJCd/w1onw3aW3Doy/MF
         mTSOo9LAUGzPKVhr5mhl//WidnVbOrzi2Uv7o+8KKXZvnmTSBqexxXi1bZGC6V9YDDu2
         X1bjs9bNYZvMYX7J73Z9zZGcPWG8TPQvk22YU=
Date: Mon, 6 Oct 2008 02:23:00 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc8+ - first impressions
Message-ID: <20081006062235.GA2808@amd.corenet.prv>
References: <20081005183603.GA3263@amd.corenet.prv> <200810052119.13881.rjw@sisk.pl> <20081005211748.GA11576@amd.corenet.prv> <200810060029.42471.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810060029.42471.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2008 at 12:29:42AM +0200, Rafael J. Wysocki wrote:
> On Sunday, 5 of October 2008, Dmitry Torokhov wrote:
> > On Sun, Oct 05, 2008 at 09:19:13PM +0200, Rafael J. Wysocki wrote:
> > > On Sunday, 5 of October 2008, Dmitry Torokhov wrote:
> > > > On Sun, Oct 05, 2008 at 08:59:49PM +0200, Rafael J. Wysocki wrote:
> > > > > On Sunday, 5 of October 2008, Dmitry Torokhov wrote:
> > > > > > Hi,
> > > > > > 
> > > > > > Lats night I loaded 2.6.27-rc8-tip for the first time on my AMD Turion
> > > > > > 64 laptop that is normally runs with Fedora distribution kernel.
> > > > > > Compared to 2.6.25 the thing is broken - hdparm reports about 3MB/sec
> > > > > > speed, fans are constantly on, everything seems sluggish.
> > > > > > 
> > > > > > Booting with hpet=force (HPET is disabled in BIOS) hangs the box
> > > > > > somewhere in tty_init.
> > > > > 
> > > > > Is that an HP box, by chance?
> > > > > 
> > > > 
> > > > Yeah, HP nx6115.
> > > 
> > > Oh well.
> > > 
> > > Please send me the output of dmidecode from it.
> > > 
> > 
> > Here you go:
> 
> Thanks.
> 
> Please see if the appended patch helps.
> 

Yep, works great, everything is zappy, hdparm reports 30Mb/s and fan is
off. Thanks a lot!

Although I wonder why this blacklist is needed now, earlier kernels were
able to cope with this condition.

-- 
Dmitry
