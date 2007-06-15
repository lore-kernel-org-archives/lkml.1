Return-Path: <linux-kernel-owner+w=401wt.eu-S1753129AbXFPHD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbXFPHD5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 03:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751619AbXFPHDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 03:03:52 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1764 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751018AbXFPHDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 03:03:52 -0400
Date: Fri, 15 Jun 2007 13:49:36 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "Renato S. Yamane" <renatoyamane@mandic.com.br>
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: Re: [Processor] Hi-Temperature showed in trip points
Message-ID: <20070615134936.GL9442@ucw.cz>
References: <46701685.1090304@mandic.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46701685.1090304@mandic.com.br>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I have a laptop Toshiba M45-S355 (with Intel Pentium M 
> Processor 750 - 1.86GHz) and trip points show me 
> hi-temperature (that is unsupported by this processor):
> 
> $ uname -a
> Linux mandachuva 2.6.21.1 #1 PREEMPT Sun May 20 22:28:53 
> BRT 2007 i686 GNU/Linux
> 
> $ cat /proc/acpi/thermal_zone/TZCL/trip_points
> critical (S5):           105 C

echo right values into trip points to lower this.

Note: Len removed that functionality in 2.6.22.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
