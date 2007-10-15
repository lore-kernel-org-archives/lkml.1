Return-Path: <linux-kernel-owner+w=401wt.eu-S1764360AbXJOC5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764360AbXJOC5S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 22:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754940AbXJOC5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 22:57:05 -0400
Received: from emerald.lightlink.com ([205.232.34.14]:15058 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbXJOC5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 22:57:04 -0400
Date: Sun, 14 Oct 2007 22:53:31 -0400
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, apiszcz@solarrain.com,
       Hans de Goede <j.w.r.degoede@hhs.nl>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: 2.6.23.1 x86 hardware monitoring bug?
Message-ID: <20071015025331.GA3676@jupiter.solarsys.private>
References: <Pine.LNX.4.64.0710141526590.3935@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0710141526590.3935@p34.internal.lan>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Justin:

(added some CCs)

* Justin Piszcz <jpiszcz@lucidpixels.com> [2007-10-14 15:30:18 -0400]:
> As a regular user, I cannot see the sensors on the A-bit board, but I can 
> see the CPU temperature, how come I can see one but not the other?
> 
> Kernel: $ uname -a
> Linux mybox 2.6.23.1 #4 SMP PREEMPT Sun Oct 14 15:20:53 EDT 2007 i686 
> GNU/Linux
> Distribution: Debian Lenny
> 
> $ sensors
> abituguru3-isa-00e0
> Adapter: ISA adapter
> 
> coretemp-isa-0000
> Adapter: ISA adapter
> temp1:       +35°C  (high =   +85°C)
> 
> coretemp-isa-0001
> Adapter: ISA adapter
> temp1:       +36°C  (high =   +85°C)
> 
> As root:
> 
> # sensors
> abituguru3-isa-00e0
> Adapter: ISA adapter
> CPU Core:               +1.35 V  (min  +0.00 V, max  +1.60 V)
> DDR2:                   +2.02 V  (min  +1.60 V, max  +2.40 V)
> DDR2 VTT:               +1.01 V  (min  +0.80 V, max  +1.20 V)
> CPU VTT 1.2V:           +1.22 V  (min  +0.95 V, max  +1.45 V)
> MCH & PCIE 1.5V:        +1.50 V  (min  +1.20 V, max  +1.80 V)
> MCH 2.5V:               +2.58 V  (min  +2.00 V, max  +3.00 V)
> ICH 1.05V:              +1.04 V  (min  +0.85 V, max  +1.25 V)
> ATX +12V (24-Pin):     +12.18 V  (min  +9.60 V, max +14.40 V)
> ATX +12V (4-pin):      +12.24 V  (min  +9.60 V, max +14.40 V)
> ATX +5V:                +5.07 V  (min  +3.99 V, max  +6.00 V)
> +3.3V:                  +3.40 V  (min  +2.64 V, max  +3.94 V)
> 5VSB:                   +5.10 V  (min  +3.99 V, max  +6.00 V)
> CPU:                      +43°C  (high =   +75°C, crit =   +85°C)
> System :                  +38°C  (high =   +55°C, crit =   +65°C)
> PWM1:                     +43°C  (high =   +80°C, crit =   +90°C)
> PWM2:                     +43°C  (high =   +80°C, crit =   +90°C)
> PWM3:                     +46°C  (high =   +80°C, crit =   +90°C)
> PWM4:                     +40°C  (high =   +80°C, crit =   +90°C)
> CPU Fan:               1380 RPM  (min  300 RPM)
> NB Fan:                   0 RPM  (min  300 RPM)
> SYS Fan:                  0 RPM  (min  300 RPM)
> AUX1 Fan:                 0 RPM  (min  300 RPM)
> AUX2 Fan:                 0 RPM  (min  300 RPM)
> AUX3 Fan:                 0 RPM  (min  300 RPM)
> OTES1 Fan:                0 RPM  (min  300 RPM)
> 
> coretemp-isa-0000
> Adapter: ISA adapter
> Core 0:      +39°C  (high =   +85°C)
> 
> coretemp-isa-0001
> Adapter: ISA adapter
> Core 1:      +39°C  (high =   +85°C)

Strange.  What does 'ls -lH /sys/class/hwmon/hwmon*/device' say?

Regards,

-- 
Mark M. Hoffman
mhoffman@lightlink.com

