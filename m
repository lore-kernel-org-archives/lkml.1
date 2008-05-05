Return-Path: <linux-kernel-owner+w=401wt.eu-S1760691AbYEEVXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760691AbYEEVXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 17:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753680AbYEEVXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 17:23:34 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:5348 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbYEEVXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 17:23:34 -0400
Date: Mon, 5 May 2008 23:22:45 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: djwong@us.ibm.com, mhoffman@lightlink.com, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH] i5k_amb: Support Intel 5400 chipset
Message-ID: <20080505232245.6003ac8a@hyperion.delvare>
In-Reply-To: <20080505135621.66809b0e.akpm@linux-foundation.org>
References: <20080503045558.GJ16078@tree.beaverton.ibm.com>
	<20080505135621.66809b0e.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Mon, 5 May 2008 13:56:21 -0700, Andrew Morton wrote:
> On Fri, 2 May 2008 21:55:59 -0700
> "Darrick J. Wong" <djwong@us.ibm.com> wrote:
> 
> > Minor rework to support the Intel 5400 chipset.
> 
> Thanks, I added this to the for-git-hwmon part of the -mm queue.
> 
> I haven't heard from Mark for quite some time so soon I might declare him
> absent and I'll go through my hwmon patches with a view to merging them into
> 2.6.26 directly.

For Mark's status see:
http://lists.lm-sensors.org/pipermail/lm-sensors/2008-May/023006.html

I guess he'll be happy if you merge a couple patches for him.

> 
> That queue currently consists of:
> 
> hdaps-invert-the-axes-for-hdaps-on-lenovo-r61i-thinkpads.patch
> adt746x-logical-bitwise-confusion-in-set_max_duty_at_crit.patch

The adt7473:set_max_duty_at_crit() code was originally confusing but
correct. After this patch the code is clear but broken. Is it
considered an improvement?

(I would have told you before if that patch had been submitted to the
lm-sensors list as it should have, given that it modifies a hardware
monitoring driver... Not to mention that the patch file name doesn't
match the driver file name, just to add to the confusion.)

> adt7473-minor-documentation-update.patch

I reviewed and acked that one, it's ready to go.

> i5k_amb-support-intel-5400-chipset.patch

-- 
Jean Delvare
