Return-Path: <linux-kernel-owner+w=401wt.eu-S1755908AbXHERN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908AbXHERN6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 13:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbXHERNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 13:13:49 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:59793 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbXHERNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 13:13:49 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46B6053E.2050708@s5r6.in-berlin.de>
Date: Sun, 05 Aug 2007 19:13:34 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.5) Gecko/20070804 SeaMonkey/1.1.3
MIME-Version: 1.0
To: "Mark M. Hoffman" <mhoffman@lightlink.com>
CC: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: 2.6.23-rc1 regression: hwmon/w83627ehf: wrong fan speed
References: <46B5B290.4040907@s5r6.in-berlin.de> <20070805162141.GI6221@jupiter.solarsys.private>
In-Reply-To: <20070805162141.GI6221@jupiter.solarsys.private>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark M. Hoffman wrote:
> Does this patch (against v2.6.23-rc2) fix it?
> 
> commit f15c50e703c14ff7d72c3cb34e8e55417476a290
> Author: Mark M. Hoffman <mhoffman@lightlink.com>
> Date:   Sun Aug 5 12:19:01 2007 -0400
> 
>     hwmon: read fan_div values during probe
>     
>     This patch forces the driver to read the fan divider values during early init.
>     Otherwise, a call to store_fan_min() could access uninitialized variables.

Alas not; there is no change.
(I applied on vanilla 2.6.23-rc2 and rebooted.)
-- 
Stefan Richter
-=====-=-=== =--- --=-=
http://arcgraph.de/sr/
