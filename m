Return-Path: <linux-kernel-owner+w=401wt.eu-S1757753AbXHEL2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753AbXHEL2v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 07:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbXHEL2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 07:28:43 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:53584 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbXHEL2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 07:28:42 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46B5B45E.3030208@s5r6.in-berlin.de>
Date: Sun, 05 Aug 2007 13:28:30 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.5) Gecko/20070804 SeaMonkey/1.1.3
MIME-Version: 1.0
To: lm-sensors@lm-sensors.org
CC: linux-kernel@vger.kernel.org, "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: 2.6.23-rc1 regression: hwmon/w83627ehf: wrong fan speed
References: <46B5B290.4040907@s5r6.in-berlin.de>
In-Reply-To: <46B5B290.4040907@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> Now that I booted from 2.6.22-rc5 to 2.6.23-rc2 I noticed that ksensors
> displayed 1/16 of the actual speed of the CPU fan (correct is ca. 1400
> RPM under light load) and 0 for the case fan (correct is ca. 480 RPM
> under light load).
> 
> I reverted patch
> 	hwmon/w83627ehf: No need to initialize fan_min
> and the behaviour changed as follows:  ksensors displays the correct CPU
> fan speed when loaded for the first time after the w83627ehf was loaded,
> then drops to 1/16th the next time it refreshes the display.  (I
> configured 30s update interval in ksensors.)  But the case fan's speed
> is now correctly displayed all the time.  Ksensors' fan speed
> multipliers are configured as 1.
...
> Booting back into 2.6.22-rc5 (which seems identical with 2.6.22 as far
> as w83627ehf is concerned) brings back the correct fan speeds.

PS:  The actual behavior under 2.6.22-rc5 is that the CPU fan speed is
displayed correctly from the start, while the case fan speed is
initially shown as 0 but jumps to the correct speed after ksensors'
first display update.
-- 
Stefan Richter
-=====-=-=== =--- --=-=
http://arcgraph.de/sr/
