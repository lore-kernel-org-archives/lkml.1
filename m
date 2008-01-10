Return-Path: <linux-kernel-owner+w=401wt.eu-S1757887AbYAJAbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887AbYAJAbn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 19:31:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755238AbYAJAbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 19:31:34 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34795 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754304AbYAJAbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 19:31:33 -0500
Date: Wed, 9 Jan 2008 16:30:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steve Hardy <steve@linuxrealtime.co.uk>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       khali@linux-fr.org, "Mark M. Hoffman" <mhoffman@lightlink.com>
Subject: Re: [PATCH 1/1] : hwmon - new chip driver for TI  ADS7828 A-D
Message-Id: <20080109163027.56fbb394.akpm@linux-foundation.org>
In-Reply-To: <20080104073439.GA22033@toshiba-lt>
References: <477D50CC.6020504@linuxrealtime.co.uk>
	<20080104073439.GA22033@toshiba-lt>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jan 2008 07:34:39 +0000
Steve Hardy <steve@linuxrealtime.co.uk> wrote:

> Andrew/Jean,
> 
> Sorry for the delay - christmas & getting mutt working delayed my
> revised patch.  Here is an updated patch against 2.6.24-rc6, which
> hopefully addresses all comments made so far.
> 
> Jean - you mentioned declaring the devices as platform data & writing
> a new-style I2C driver - are there any examples of this approach I can
> refer to?  I simply copied what is/was currently in-tree for this
> driver, which seems to work well with the hardware I'm working with (a
> COTS CPCI carrier)
> 
> Since I've dropped Thunderbird I hope the patch mangling will be
> fixed.
> 
> Any problem, please let me know.
>

The above doesn't constitute a usable changelog.  I guess we don't really
need anything in this patch but please do remember that the changelog text
should be included in each new rev of a patch.

> 
> Signed-Off by Steve Hardy <steve@linuxrealtime.co.uk>

"Signed-off-by:", please.

 Documentation/hwmon/ads7828 |   38 ++++
 drivers/hwmon/Kconfig       |   10 +
 drivers/hwmon/Makefile      |    1 
 drivers/hwmon/ads7828.c     |  296 ++++++++++++++++++++++++++++++++++
 4 files changed, 345 insertions(+)

I assumed that this is to be merged via Mark's git-hwmon tree.
