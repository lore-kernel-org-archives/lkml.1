Return-Path: <linux-kernel-owner+w=401wt.eu-S1759369AbYG1Qvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759369AbYG1Qvu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 12:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757568AbYG1Qt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 12:49:27 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:55576 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759913AbYG1Qt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 12:49:26 -0400
Date: Mon, 28 Jul 2008 10:49:22 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: T Ziomek <ctz001@email.mot.com>
Cc: Milton Miller <miltonm@bga.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, Jeremy Kerr <jk@ozlabs.org>
Subject: Re: [RFC,PATCH] scripts/package: add powerpc images to tarball
Message-ID: <20080728164922.GA21159@secretlab.ca>
References: <1216887460.306306.238738123378.1.gpush@pingu> <200807250108.m6P18f4B099179@sullivan.realtime.net> <fa686aa40807252155l4f785920qdb14d117067b30f4@mail.gmail.com> <913573e2092839fbe37a0bfa37119eb6@bga.com> <fa686aa40807261053r5a8ebe40l7e8061f926f185f9@mail.gmail.com> <20080728163435.GE27068@email.mot.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080728163435.GE27068@email.mot.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 11:34:35AM -0500, T Ziomek wrote:
> On Sat, Jul 26, 2008 at 01:53:57PM -0400, Grant Likely wrote:
>  . . .
> > Come to think of it, I'd support just removing the zImage symlink
> > entirely to eliminate confusion so that everyone knows that 'make
> > zImage' is the 'make all' for default image targets.
> 
> That ("zImage" means all default image targets) seems pretty non-intui-
> tive; why not something like 'make all_def_images'?

It is purely historical.  zImage and modules have been the default
make targets for a long time.  I'm not opposed to changing it, but it is
a change that affects almost everyone.  I'd like to see some consensus
before going down this path.

g.

