Return-Path: <linux-kernel-owner+w=401wt.eu-S1759640AbXLTJ6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759640AbXLTJ6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 04:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755099AbXLTJ6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 04:58:12 -0500
Received: from smtp-104-thursday.nerim.net ([62.4.16.104]:58073 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755000AbXLTJ6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 04:58:11 -0500
Date: Thu, 20 Dec 2007 10:58:08 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: lm-sensors <lm-sensors@lm-sensors.org>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] adt7470: Support per-sensor alarm files
Message-ID: <20071220105808.1d9a044b@hyperion.delvare>
In-Reply-To: <20071219221124.GP6870@tree.beaverton.ibm.com>
References: <20071219040123.GN6870@tree.beaverton.ibm.com>
	<20071219154012.18302de5@hyperion.delvare>
	<20071219221124.GP6870@tree.beaverton.ibm.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darrick,

On Wed, 19 Dec 2007 14:11:25 -0800, Darrick J. Wong wrote:
> On Wed, Dec 19, 2007 at 03:40:12PM +0100, Jean Delvare wrote:
> > In general we keep the all-in-one alarms file for compatibility, but
> > given that this driver is fairly new and libsensors never had specific
> > support for it anyway, it's probably OK to drop it this time.
> 
> Thanks for the code review.  I've made the changes you asked for and
> here's a new patch to supersede yesterday's.
> ---
> Remove the old alarms hack and replace it with per-sensor alarm files.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

Looks alright to me this time.

Acked-by: Jean Delvare <khali@linux-fr.org>

BTW, did you try your driver with lm-sensors 3.0.0?

Thanks,
-- 
Jean Delvare
