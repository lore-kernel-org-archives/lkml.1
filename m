Return-Path: <linux-kernel-owner+w=401wt.eu-S1762610AbXJYUY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762610AbXJYUY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 16:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbXJYUYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 16:24:43 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55351 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760136AbXJYUYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 16:24:41 -0400
Date: Thu, 25 Oct 2007 13:24:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: trenn@suse.de, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       lenb@kernel.org
Subject: Re: [PATCH 0/5] Detect hwmon and i2c bus drivers interfering with 
 ACPI Operation Region resources
Message-Id: <20071025132410.7ae184a8.akpm@linux-foundation.org>
In-Reply-To: <20071025155135.019baca3@hyperion.delvare>
References: <1193236319.4590.225.camel@queen.suse.de>
	<20071024205723.458fab97.akpm@linux-foundation.org>
	<20071025155135.019baca3@hyperion.delvare>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007 15:51:35 +0200
Jean Delvare <khali@linux-fr.org> wrote:

> On Wed, 24 Oct 2007 20:57:23 -0700, Andrew Morton wrote:
> > On Wed, 24 Oct 2007 16:31:59 +0200 Thomas Renninger <trenn@suse.de> wrote:
> > 
> > > it seems Len's test tree and Linus tree diverged a bit, at least with
> > > this patch set things do not apply cleanly.
> > > 
> > > Therefore I post these for discussion whether and in which kernel tree
> > > they should end up before doing work for nothing.
> > > If they are still a candidate for 2.6.24 (rather unintrusive), pls tell
> > > me whether and when I should base them against Len's test/release branch
> > > or whatever other tree.
> > > If not, it would be great if they can be included into the -mm tree and
> > > I can rebase them against this one.
> > 
> > I staged the three acpi patches against Len's tree and I staged the hwmon
> > patch against Mark's tree and I staged the I2C patch against Jean's tree.
> > 
> > This means that if/when the ACPI patches have gone me->Len->Linus, I can
> > send the I2C patch to Jean and the hwmon patch to Mark and we're all good.
> 
> Thanks for picking these patches, having them in -mm for some time is
> exactly what we need. Let's see how many systems are affected by the
> resource conflicts and how we can fix them

No probs.  The main thing is to ensure that we have sufficient debug
support in that patch so that if a tester does report a problem, we (ie:
you ;) can resolve it on the first pass.  So feel free to make it really
noisy - we can always drop the debug stuff later on.

Also, please try to avoid adding anythig which would disrupt that tester
from going on and testing all the other new code.  ie: try to fail
gracefully and fall back to the old behaviour.
