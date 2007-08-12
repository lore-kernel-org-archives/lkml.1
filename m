Return-Path: <linux-kernel-owner+w=401wt.eu-S932843AbXHLKoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932843AbXHLKoK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 06:44:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbXHLKn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 06:43:59 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:37513 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbXHLKn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 06:43:58 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46BEE469.8080403@s5r6.in-berlin.de>
Date: Sun, 12 Aug 2007 12:43:53 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: "Mark M. Hoffman" <mhoffman@lightlink.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1 regression: hwmon/w83627ehf: wrong fan speed
References: <46B5B290.4040907@s5r6.in-berlin.de>	<20070805162141.GI6221@jupiter.solarsys.private>	<46B6053E.2050708@s5r6.in-berlin.de>	<20070810230831.59cbc50f@hyperion.delvare>	<46BCE6D0.7060300@s5r6.in-berlin.de>	<20070811135705.0d0688d7@hyperion.delvare>	<46BDD8B3.8070708@s5r6.in-berlin.de> <20070812111713.1afb24c6@hyperion.delvare> <46BEE247.4040904@s5r6.in-berlin.de>
In-Reply-To: <46BEE247.4040904@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> Jean Delvare wrote:
>> One remaining mystery is why you did not observe the problem with the
>> older kernel. Maybe the ACPI thermal driver was not loaded (or not
>> working) back then?
> 
> I found two differences:  Gentoo's udev init script autoloads thermal on
> boot under 2.6.23-rc2 but it doesn't under 2.6.22(-rc5), for a reason
> unknown to me.  If I manually load thermal under 2.6.22(-rc5),
[...]

The reason are obviously some post 2.6.22/ pre 2.6.23-rc1 commits which
add module aliases to ACPI drivers.
-- 
Stefan Richter
-=====-=-=== =--- -==--
http://arcgraph.de/sr/
