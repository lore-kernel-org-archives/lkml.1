Return-Path: <linux-kernel-owner+w=401wt.eu-S1751266AbZIUEFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751266AbZIUEFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 00:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750795AbZIUEFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 00:05:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53132 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750782AbZIUEFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 00:05:42 -0400
Date: Sun, 20 Sep 2009 21:04:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Michael Hennerich <michael.hennerich@analog.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [Uclinux-dist-devel] [PATCH] input/keyboard: new driver for 
 ADP5520 MFD PMICs
Message-Id: <20090920210451.60ad1b1f.akpm@linux-foundation.org>
In-Reply-To: <8bd0f97a0909201540t25dd2337o15ebe63a2a9ca4ec@mail.gmail.com>
References: <1253211850-29309-1-git-send-email-vapier@gentoo.org>
	<20090919233044.8361a912.akpm@linux-foundation.org>
	<8bd0f97a0909201540t25dd2337o15ebe63a2a9ca4ec@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Sep 2009 18:40:41 -0400 Mike Frysinger <vapier.adi@gmail.com> wrote:

> On Sun, Sep 20, 2009 at 02:30, Andrew Morton wrote:
> > On Thu, 17 Sep 2009 14:24:10 -0400 Mike Frysinger wrote:
> >> +struct adp5520_keys {
> >> + __ __ struct input_dev *input;
> >> + __ __ struct notifier_block notifier;
> >> + __ __ struct device *master;
> >> + __ __ unsigned short keycode[ADP5520_KEYMAPSIZE];
> >
> > Where is ADP5520_KEYMAPSIZE defined?
> 
> all these things are in the common mfd adp5520 patch.  it introduces a
> common adp5520 header.

err, what common MFD patch?  There was nothing in either the changelog
nor the patch title which indicated that this patch had a dependency on
other patches.  This makes things harder for mergers and reviewers,
especially when the patchset hits multiple subsystems, maintained by
multiple developers.

Probably the best way to handle this sort of thing is to present it as a
sequence-numbered patch series with well-chosen cc's and an overall
description of the dependencies and perhaps the merge plan in [patch
0/n].

