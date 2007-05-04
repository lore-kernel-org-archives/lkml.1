Return-Path: <linux-kernel-owner+w=401wt.eu-S1030949AbXEDWkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030949AbXEDWkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 18:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031275AbXEDWkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 18:40:00 -0400
Received: from lug.demon.co.uk ([83.104.159.110]:39227 "EHLO lug.demon.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030949AbXEDWj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 18:39:59 -0400
X-Greylist: delayed 1143 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 May 2007 18:39:59 EDT
From: David Johnson <dj@david-web.co.uk>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: cpufreq longhaul locks up
Date: Fri, 4 May 2007 23:20:40 +0100
User-Agent: KMail/1.9.5
References: <Pine.LNX.4.61.0705041200370.18504@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0705041200370.18504@yvahk01.tjqt.qr>
Cc: linux-kernel@vger.kernel.org, cpufreq@lists.linux.org.uk
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705042320.41278.dj@david-web.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 May 2007 11:16, you wrote:
>
> I found that setting the cpufreq governor to ondemand making the box
> lock up solid in 2.6.20.2 and 2.6.21 after a few seconds. Sysrq
> does not work anymore, and the last messages are:
>

I've been seeing a similar issue, but with a few differences.
I'm running 2.6.21.1 on the same CPU as yourself:

longhaul: VIA C3 'Nehemiah C' [C5P] CPU detected.  Powersaver supported.
longhaul: Using ACPI support.

It seems that longhaul on my system is 'using ACPI support' whereas on yours 
it is 'using northbridge support'. I'm getting lockups after approx. 2-3 
hours using the ondemand governor. It has no problem changing the clock 
speed, and runs at the minimum speed most of the time.

I seem to recall that I get an oops when my system locks-up (the system runs 
headless normally, so it isn't easy to check). I'll investigate.

Regards,
David.

-- 
David Johnson
www.david-web.co.uk
