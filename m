Return-Path: <linux-kernel-owner+w=401wt.eu-S1757245AbZCEQok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245AbZCEQok (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 11:44:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754864AbZCEQoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 11:44:30 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:36353 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024AbZCEQo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 11:44:29 -0500
Date: Thu, 5 Mar 2009 17:44:18 +0100
From: Jean Delvare <khali@linux-fr.org>
To: djwong@us.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH] lm90: Support the MAX6648/6692 chips
Message-ID: <20090305174418.02fd9593@hyperion.delvare>
In-Reply-To: <20090305154729.GL6550@plum>
References: <20090302210106.GD6550@plum>
	<20090305152517.4e0b8983@hyperion.delvare>
	<20090305154729.GL6550@plum>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darrick,

On Thu, 5 Mar 2009 07:47:30 -0800, Darrick J. Wong wrote:
> On Thu, Mar 05, 2009 at 03:25:17PM +0100, Jean Delvare wrote:
> > I am confused. According to my notes, the MAX6648/MAX6692 is the same
> > chip as the MAX6646/MAX6647/MAX6649 (same chip ID of 0x59), the only
> > difference being the I2C address (0x4c for the MAX6646, 0x4e for the
> > MAX6647 and 0x4d for the MAX6648/MAX6649/MAX6692). So the current code
> > should _already_ detect your MAX6648 or MAX6692 as kind = max6646.
> 
> Heh, yep, it does.  I guess this patch has been sitting around long
> enough to become obsolete, sorry for the unnecessary mail traffic.  I
> guess we can drop this one.

Well, confusion probably would have been avoided if it had been
properly documented that the MAX6648 and MAX6692 were already
supported. So I think we should still apply the Kconfig part of your
patch. Documentation/hwmon/lm90 would need a small update as well.
Could you please send an updated patch doing this? I would be happy to
apply that.

Thanks,
-- 
Jean Delvare
