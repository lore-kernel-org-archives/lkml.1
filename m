Return-Path: <linux-kernel-owner+w=401wt.eu-S1755972AbXIARS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbXIARS5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 13:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbXIARSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 13:18:48 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1030 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752475AbXIARSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 13:18:47 -0400
Date: Sat, 1 Sep 2007 17:10:48 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Jean Delvare <khali@linux-fr.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [PATCH] hwmon: Add power meters to Documentation/hwmon/sysfs-interface
Message-ID: <20070901171048.GA3883@ucw.cz>
References: <20070827211446.GG32667@tree.beaverton.ibm.com> <20070828015029.GA10107@khazad-dum.debian.net> <20070828131942.18449886@hyperion.delvare> <20070828164440.GL32667@tree.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070828164440.GL32667@tree.beaverton.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> diff --git a/Documentation/hwmon/sysfs-interface b/Documentation/hwmon/sysfs-interface
> index b3a9e1b..da546ce 100644
> --- a/Documentation/hwmon/sysfs-interface
> +++ b/Documentation/hwmon/sysfs-interface
> @@ -304,6 +304,21 @@ curr[1-*]_input	Current input value
>  		Unit: milliampere
>  		RO
>  
> +*********
> +* Power *
> +*********
> +
> +power[1-*]_input	Current power use
> +			Unit: milliWatt
> +			RO
> +
> +power[1-*]_max_input	Historical maximum power use
> +			Unit: milliWatt
> +			RO
> +
> +power[1-*]_min_input	Historical minimum power use
> +			Unit: milliWatt
> +			RO

Should we add power?_10sec_avg_input? IIRC thinkpads export that,
too.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
