Return-Path: <linux-kernel-owner+w=401wt.eu-S1754461AbZBNXBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbZBNXBf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 18:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752604AbZBNXB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 18:01:27 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:49579 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344AbZBNXB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 18:01:27 -0500
X-Greylist: delayed 1389 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Feb 2009 18:01:27 EST
Subject: Re: cpuinfo shows wrong MHz value
From: Kasper Sandberg <lkml@metanurb.dk>
To: Frans Pop <elendil@planet.nl>
Cc: Joerg Platte <jplatte@naasa.net>, linux-kernel@vger.kernel.org
In-Reply-To: <200902142329.31428.elendil@planet.nl>
References: <200902142217.51655.jplatte@naasa.net>
	 <200902142329.31428.elendil@planet.nl>
Content-Type: text/plain
Date: Sat, 14 Feb 2009 23:38:16 +0100
Message-Id: <1234651096.13338.15.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-02-14 at 23:29 +0100, Frans Pop wrote:
> Joerg Platte wrote:
> > I'm running kernel 2.6.28.4 and /proc/cpuinfo and powertop and vmware
> > are unable to detect the correct speed (1.6 GHz) of the processor:
> 
> Isn't this just the result of frequency scaling? Is the processor busy 
> when you check /proc/cpuinfo?

I dont think cpu frequency scaling can suddenly make a cpu go from
1.6ghz to 13ghz, but if it can, i sure want one!

> 
> What are the values in:
> /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
> /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies
> /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
> ?
> 
> Cheers,
> FJP
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

