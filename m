Return-Path: <linux-kernel-owner+w=401wt.eu-S1752131AbXLVL7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbXLVL7Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 06:59:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754267AbXLVL7B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 06:59:01 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:50487 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbXLVL6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 06:58:54 -0500
Date: Sat, 22 Dec 2007 11:52:17 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Balbir Singh <balbir@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC] [PATCH] Memory controller remove control_type feature
In-Reply-To: <476CBD9B.9070203@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.64.0712221140330.7460@blonde.wat.veritas.com>
References: <20071220185358.3248.25416.sendpatchset@balbir-laptop>
 <20071221225941.98b7362d.akpm@linux-foundation.org> <476CBD9B.9070203@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Dec 2007, Balbir Singh wrote:
> Andrew Morton wrote:
> > On Fri, 21 Dec 2007 00:23:58 +0530 Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 
> >> Based on the discussion at http://lkml.org/lkml/2007/12/20/383, it was
> >> felt that control_type might not be a good thing to implement right away.
> >> We can add this flexibility at a later point when required.

Not studied closely, but your patch looks both too much and too
little to me, Balbir.

Too much in that it appears to bundle in some significant little
locking changes without any mention in the commment.

Too little in that it leaves behind lots of junk relating to the
different control_types: the enums, the different kinds of call
that needn't now be different, no change to the various callsites.
Needs more cleanup, I'd say.  Of course, that could be yet another
separate patch.

> > Gee the memory controller patchset is turning into a mess.

A mess indeed.

> Yes, the patchset has expanded and we have several useful bug fixes and
> cleanups and some new features.

Hah, a career in politics beckons ;)

> > Hopefully it'll look a bit better once I do a big patch-folding but we
> > still have patches interesecting everywhere and now we have patches which
> > add a feature and later ones which take it away again.
> > 
> 
> I think folding will help. I understand your concern w.r.t getting the
> correct set of patches with a good changelog.
> 
> > But I don't think it's worth the time and risk of a huge
> > rip-up-and-refactor.
> > 
> 
> I agree, given the proximity of the new merge window for 2.6.25.  We
> could review the patches after folding them and see how to consolidate
> further in case the patches continue to look messy.

Personally, I think it could benefit a lot from a rip-up-and-refactor.
But if we're rushing headlong for 2.6.25, yes, I agree it's too late.
And I'm afraid it's not something I can volunteer for at this time.

Hugh
