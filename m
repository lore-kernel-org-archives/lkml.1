Return-Path: <linux-kernel-owner+w=401wt.eu-S1758654AbXJYNvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654AbXJYNvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 09:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbXJYNvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 09:51:38 -0400
Received: from smtp-104-thursday.nerim.net ([62.4.16.104]:52853 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754621AbXJYNvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 09:51:37 -0400
Date: Thu, 25 Oct 2007 15:51:35 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: trenn@suse.de, linux-acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 0/5] Detect hwmon and i2c bus drivers interfering with 
 ACPI Operation Region resources
Message-ID: <20071025155135.019baca3@hyperion.delvare>
In-Reply-To: <20071024205723.458fab97.akpm@linux-foundation.org>
References: <1193236319.4590.225.camel@queen.suse.de>
	<20071024205723.458fab97.akpm@linux-foundation.org>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007 20:57:23 -0700, Andrew Morton wrote:
> On Wed, 24 Oct 2007 16:31:59 +0200 Thomas Renninger <trenn@suse.de> wrote:
> 
> > it seems Len's test tree and Linus tree diverged a bit, at least with
> > this patch set things do not apply cleanly.
> > 
> > Therefore I post these for discussion whether and in which kernel tree
> > they should end up before doing work for nothing.
> > If they are still a candidate for 2.6.24 (rather unintrusive), pls tell
> > me whether and when I should base them against Len's test/release branch
> > or whatever other tree.
> > If not, it would be great if they can be included into the -mm tree and
> > I can rebase them against this one.
> 
> I staged the three acpi patches against Len's tree and I staged the hwmon
> patch against Mark's tree and I staged the I2C patch against Jean's tree.
> 
> This means that if/when the ACPI patches have gone me->Len->Linus, I can
> send the I2C patch to Jean and the hwmon patch to Mark and we're all good.

Thanks for picking these patches, having them in -mm for some time is
exactly what we need. Let's see how many systems are affected by the
resource conflicts and how we can fix them

-- 
Jean Delvare
