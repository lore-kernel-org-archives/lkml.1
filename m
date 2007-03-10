Return-Path: <linux-kernel-owner+w=401wt.eu-S933506AbXCJHMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933506AbXCJHMK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 02:12:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933507AbXCJHMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 02:12:09 -0500
Received: from gateway.insightbb.com ([74.128.0.19]:24324 "EHLO
	asav04.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933506AbXCJHMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 02:12:08 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlwPANLo8UVKhRO4UGdsb2JhbACCBIVNh18BASo
From: Dmitry Torokhov <dtor@insightbb.com>
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] Use attribute groups in struct device_type
Date: Sat, 10 Mar 2007 02:12:04 -0500
User-Agent: KMail/1.9.3
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <200703100137.35203.dtor@insightbb.com> <20070310065443.GA20302@suse.de> <20070310065556.GB20302@suse.de>
In-Reply-To: <20070310065556.GB20302@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703100212.05770.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 March 2007 01:55, Greg KH wrote:
> On Fri, Mar 09, 2007 at 10:54:43PM -0800, Greg KH wrote:
> > On Sat, Mar 10, 2007 at 01:37:34AM -0500, Dmitry Torokhov wrote:
> > > Greg,
> > > 
> > > Please consider applying the patch below. It switches struct device_type
> > > to using attribute groups which os more flexible. I am using it in my
> > > input class_device -> device conversion (which is 99% done btw).
> > 
> > Argh, I never sent you my version of that, did I?  Very sorry about
> > that, I was working on fixing up the device namespace issue first, which
> > isn't done yet :(
> > 
> > Anyway, my patch that did that is below, feel free to use it or not if
> > you want.
> > 
> > > I looked through -mm and the latest git and there does not seem to be
> > > any users of struct device_type yet...
> > 
> > Yes, the input patch below uses it and I have a block-device patch from
> > Kay in my tree that Andrew doesn't pull from (as it's usually really
> > messed up and I know to hide this kind of breakage from him...)
> 
> Oops, that patch didn't use it, this follow-on patch from Kay uses them.
> 

Ok, so input portion in your tree does not use type->attrs so we don't
have a conflict here. Unless my patch messes up Kay's blockdev patch
badly I'd like you to accept it. Input uses 3 attribute groups and I
don't want to open-code their creation/removal.

-- 
Dmitry
