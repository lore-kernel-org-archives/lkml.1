Return-Path: <linux-kernel-owner+w=401wt.eu-S1753119AbZIUSYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbZIUSYi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 14:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbZIUSYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 14:24:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35373 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752621AbZIUSYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 14:24:35 -0400
Date: Mon, 21 Sep 2009 11:23:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Michael Hennerich <michael.hennerich@analog.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [Uclinux-dist-devel] [PATCH] input/keyboard: new driver for 
 ADP5520 MFD PMICs
Message-Id: <20090921112346.12832b27.akpm@linux-foundation.org>
In-Reply-To: <8bd0f97a0909210640q3ead3467gcccac227a9088d76@mail.gmail.com>
References: <1253211850-29309-1-git-send-email-vapier@gentoo.org>
	<20090919233044.8361a912.akpm@linux-foundation.org>
	<8bd0f97a0909201540t25dd2337o15ebe63a2a9ca4ec@mail.gmail.com>
	<20090920210451.60ad1b1f.akpm@linux-foundation.org>
	<8bd0f97a0909210640q3ead3467gcccac227a9088d76@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Sep 2009 09:40:46 -0400 Mike Frysinger <vapier.adi@gmail.com> wrote:

> On Mon, Sep 21, 2009 at 00:04, Andrew Morton wrote:
> > On Sun, 20 Sep 2009 18:40:41 -0400 Mike Frysinger wrote:
> >> On Sun, Sep 20, 2009 at 02:30, Andrew Morton wrote:
> >> > On Thu, 17 Sep 2009 14:24:10 -0400 Mike Frysinger wrote:
> >> >> +struct adp5520_keys {
> >> >> + __ __ struct input_dev *input;
> >> >> + __ __ struct notifier_block notifier;
> >> >> + __ __ struct device *master;
> >> >> + __ __ unsigned short keycode[ADP5520_KEYMAPSIZE];
> >> >
> >> > Where is ADP5520_KEYMAPSIZE defined?
> >>
> >> all these things are in the common mfd adp5520 patch. __it introduces a
> >> common adp5520 header.
> >
> > err, what common MFD patch? __There was nothing in either the changelog
> > nor the patch title which indicated that this patch had a dependency on
> > other patches. __This makes things harder for mergers and reviewers,
> > especially when the patchset hits multiple subsystems, maintained by
> > multiple developers.
> >
> > Probably the best way to handle this sort of thing is to present it as a
> > sequence-numbered patch series with well-chosen cc's and an overall
> > description of the dependencies and perhaps the merge plan in [patch
> > 0/n].
> 
> the MFD patch has been sent to the MFD guy already for review.  being
> an MFD means it touches like 4 or 5 different subsystems.  but the
> only dependency is on the MFD core.

What you said has nothing to do with what I said.

As the patch was presented, Dmitry or I could well have merged it only
to find out that it doesn't compile.

