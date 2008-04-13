Return-Path: <linux-kernel-owner+w=401wt.eu-S1757493AbYDMAWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493AbYDMAWw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 20:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754789AbYDMAWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 20:22:43 -0400
Received: from smtp.ono.com ([62.42.230.12]:42557 "EHLO resmaa05.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754635AbYDMAWm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 20:22:42 -0400
Date: Sun, 13 Apr 2008 02:22:39 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: "Linux-Kernel, " <linux-kernel@vger.kernel.org>
Subject: Re: DRDY errors again
Message-ID: <20080413022239.79fb3713@werewolf.home>
In-Reply-To: <87d4ozpuc3.fsf@old-tantale.fifi.org>
References: <E1JjLYm-0002d7-00@calista.eckenfels.net>
	<87d4ozpuc3.fsf@old-tantale.fifi.org>
X-Mailer: Claws Mail 3.3.1cvs55 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08 Apr 2008 20:42:36 -0700, Philippe Troin <phil@fifi.org> wrote:

> Bernd Eckenfels <ecki@lina.inka.de> writes:
> 
> > Besides the disk it could also be a voltage problem (voltage control on
> > mainboard or power supply). I asume you ruled out thermal problems...
> 
> I would completely second that.  In multiple instances, I've had
> different disks behave very strangely when the power supply became
> flaky (12V at 11.3V and/or 5V hovering around 4.5V).  And there seems
> to be lots of flaky power supplies around these days.
> 

Acording to my sensors...:

werewolf:/etc# sensors
w83627thf-isa-0290
Adapter: ISA adapter
VCore:       +1.48 V  (min =  +0.70 V, max =  +1.87 V)
+12V:       +12.22 V  (min = +10.82 V, max = +13.19 V)
+3.3V:       +3.34 V  (min =  +3.14 V, max =  +3.47 V)
+5V:         +5.04 V  (min =  +4.75 V, max =  +5.25 V)
V5SB:        +5.08 V  (min =  +4.76 V, max =  +5.24 V)
VBat:        +3.09 V  (min =  +2.40 V, max =  +3.60 V)
CPU0 Fan:   2343 RPM  (min =  499 RPM, div = 16)
CPU1 Fan:   2280 RPM  (min =  499 RPM, div = 16)
Chas Fan:   2343 RPM  (min =  499 RPM, div = 16)
VRM  Temp:   +50.0°C  (high = +60.0°C, hyst = +35.0°C)  sensor = thermistor
CPU0 Temp:   +43.0°C  (high = +70.0°C, hyst = +40.0°C)  sensor = thermistor
CPU1 Temp:   +41.5°C  (high = +70.0°C, hyst = +40.0°C)  sensor = thermistor

so it all look correct.

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2008.1 (Cooker) for i586
Linux 2.6.23-jam05 (gcc 4.2.2 20071128 (4.2.2-2mdv2008.1)) SMP PREEMPT
