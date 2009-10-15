Return-Path: <linux-kernel-owner+w=401wt.eu-S1757874AbZJOIGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874AbZJOIGm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 04:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755604AbZJOIGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 04:06:41 -0400
Received: from poutre.nerim.net ([62.4.16.124]:65438 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755286AbZJOIGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 04:06:36 -0400
Date: Thu, 15 Oct 2009 10:05:57 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [lm-sensors] lm-sensors 3.1.1-3 not detecting sensors on Intel
  DP55KG motherboard? (chip ID: 0xb473)
Message-ID: <20091015100557.22243433@hyperion.delvare>
In-Reply-To: <alpine.DEB.2.00.0910140856190.19307@p34.internal.lan>
References: <alpine.DEB.2.00.0910131743530.5034@p34.internal.lan>
	<alpine.DEB.2.00.0910140403150.15961@p34.internal.lan>
	<alpine.DEB.2.00.0910140856190.19307@p34.internal.lan>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Justin,

On 13/14 Oct 2009, Justin Piszcz wrote:
> # uname -a
> Linux box 2.6.31.3 #2 SMP Wed Oct 14 04:55:36 EDT 2009 x86_64 GNU/Linux
> 
> I have a DP55KG motherboard, it says Ibex support was added here:
> http://www.lm-sensors.org/changeset/5375
> 
> # sensors
> No sensors found!
> Make sure you loaded all the kernel drivers you need.
> Try sensors-detect to find out which these are.
> 
> I have all of the modules compiled into the kernel and sensors-detect does 
> not find anything.
> 
> 00:1f.3 SMBus: Intel Corporation Ibex Peak SMBus Controller (rev 05)
> 
> Any ideas?

The "Ibex support" in question only refers to the SMBus controller, not
to sensors directly.

> I tried w83627ehf, to no avail:
>
> # modprobe w83627ehf
> FATAL: Error inserting w83627ehf 
> (/lib/modules/2.6.31.3/kernel/drivers/hwmon/w83627ehf.ko): No such device
>
> (...)
> With debugging enabled:
> 
> [56208.376451] w83627ehf: unsupported chip ID: 0xb473
> 
> Is there anything else needed from me/info about the board or once this ID 
> is added into the kernel/src/etc it will work properly?

We have never heard of this chip ID. This must be a brand new
Winbond/Nuvoton Super-I/O chip. Please look at the motherboard, search
for the Super-I/O and report the top marking. You may also find its
name in the user manual (but the top marking is even more reliable.)

-- 
Jean Delvare
