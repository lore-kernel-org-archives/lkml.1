Return-Path: <linux-kernel-owner+w=401wt.eu-S1757343AbXHEQgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343AbXHEQgE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 12:36:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbXHEQf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 12:35:56 -0400
Received: from phoenix.bawue.net ([193.7.176.60]:36942 "EHLO mail.bawue.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751924AbXHEQfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 12:35:55 -0400
Date: Sun, 5 Aug 2007 18:27:47 +0200
From: Joerg Sommrey <jo@sommrey.de>
To: Rene Herman <rene.herman@gmail.com>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: bad temperature values from w83781d in 2.6.22
Message-ID: <20070805162747.GA30184@sommrey.de>
Mail-Followup-To: Joerg Sommrey <jo@sommrey.de>,
	Rene Herman <rene.herman@gmail.com>,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>
References: <20070805102604.GA9123@sommrey.de> <46B5B277.8060402@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46B5B277.8060402@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your reply.

the sensors.conf I'm currently using is provided by Tyan, so this seems
to be ok.  One major difference that I can see: I don't have compute
statements for the CPU temperatures.  If I use your config, I get 7.8°C
:-)

So there is definitely some difference in our hardware environment. OTOH
with the "right" compute statement the problem seems fixable.

BTW: there is another hwmon chip on the board, a w83627hf.  Up to 2.6.21
this was managed by the w83781d driver, too.  Now I use the w83627hf
driver (on the isa bus).  No problem with that part.

-jo

On Sun, Aug 05, 2007 at 01:20:23PM +0200, Rene Herman wrote:
> On 08/05/2007 12:26 PM, Joerg Sommrey wrote:
> 
> >after upgrading from 2.6.21 to 2.6.22 the CPU temperatures shown by
> >w83781d look unreal.  They were in a range from 40°C when idle to
> >75°C under full load with 2.6.21.  The values shown now are in a very
> >small range from 77°C to 82°C.  From the (low) noise of the fan I can
> >tell that the temperature is <50°C.
> >The third temperature shown is completely wrong.
> >
> >I have a Tyan Tiger MPX board with a w83782d chip. Output from
> >"sensors":
> >
> >w83782d-i2c-0-2d
> >Adapter: SMBus AMD768 adapter at 80e0
> 
> As a datapoint, the same W83782D on AMD756 (also I2C) works correctly with 
> 2.6.22:
> 
> w83782d-i2c-0-2d
> Adapter: SMBus AMD756 adapter at 50e0
> 
> Jean Delvare recently worked on the ISA interface to these chips but it 
> seems this would not be the cause if you are also using I2C. Our hardware 
> appears rather identical...
> 
> I've attached (an excerpt of) my /etc/sensors.conf -- I once dug through 
> the datasheets for those compute lines for example so perhaps its still 
> useful even if 2.6.21 working for you probably means you don't have a 
> config problem.
> 
> Rene.
> 
