Return-Path: <linux-kernel-owner+w=401wt.eu-S1757667AbYA0Omf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667AbYA0Omf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 09:42:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563AbYA0Om2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 09:42:28 -0500
Received: from emerald.lightlink.com ([205.232.34.14]:22124 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330AbYA0Om1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 09:42:27 -0500
Date: Sun, 27 Jan 2008 09:39:03 -0500
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Jean Delvare <khali@linux-fr.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH] adt7470: Support per-sensor alarm files
Message-ID: <20080127143903.GC29892@jupiter.solarsys.private>
References: <20071219040123.GN6870@tree.beaverton.ibm.com> <20071219154012.18302de5@hyperion.delvare> <20071219221124.GP6870@tree.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071219221124.GP6870@tree.beaverton.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darrick:

* Darrick J. Wong <djwong@us.ibm.com> [2007-12-19 14:11:25 -0800]:
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
> ---
> 
>  drivers/hwmon/adt7470.c |   96 +++++++++++++++++++++++++++++++++++++++++------
>  1 files changed, 84 insertions(+), 12 deletions(-)

Applied to hwmon-2.6.git/testing, thanks.

-- 
Mark M. Hoffman
mhoffman@lightlink.com

