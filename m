Return-Path: <linux-kernel-owner+w=401wt.eu-S1758383AbXFUTCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758383AbXFUTCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 15:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbXFUTCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 15:02:11 -0400
Received: from ms.trustica.cz ([82.208.32.68]:36329 "EHLO ms.trustica.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433AbXFUTCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 15:02:09 -0400
Message-ID: <467ACB2A.4070707@assembler.cz>
Date: Thu, 21 Jun 2007 21:02:02 +0200
From: Rudolf Marek <r.marek@assembler.cz>
User-Agent: Mozilla-Thunderbird 2.0.0.0 (X11/20070601)
MIME-Version: 1.0
To: Luca Tettamanti <kronos.it@gmail.com>
CC: lm-sensors@lm-sensors.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [lm-sensors] [RFC] ACPI based hwmon driver for ASUS
References: <20070513223329.GA29207@dreamland.darkstar.lan> <46520F36.4080006@assembler.cz> <68676e00705211453n69de6868lc5da2cad64f65699@mail.gmail.com> <46528B6F.3050701@assembler.cz> <20070602222829.GA11893@dreamland.darkstar.lan>
In-Reply-To: <20070602222829.GA11893@dreamland.darkstar.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again,

Of course it is not there because I removed it myself :/ The "sensors" command 
will just produce "general parse error" this is because of the unknown device 
class (imho). So I removed that and forgot. Well now I have the sysfs files:

/sys/class/hwmon/hwmon2/device/:
bus         fan0_min    fan2_input  fan3_label    in0_input  in1_label  in2_max 
    in3_min    temp0_crit   temp1_input
driver      fan1_input  fan2_label  fan3_max      in0_label  in1_max    in2_min 
    name       temp0_input  temp1_label
fan0_input  fan1_label  fan2_max    fan3_min      in0_max    in1_min 
in3_input  path       temp0_label  temp1_max
fan0_label  fan1_max    fan2_min    hid           in0_min    in2_input 
in3_label  power      temp0_max    uevent
fan0_max    fan1_min    fan3_input  hwmon:hwmon2  in1_input  in2_label  in3_max 
    subsystem  temp1_crit


Please note that in kernelsrc/Documentation/hwmon/sysfs-interface
is defined the interface. We have fans starting from 1 and not 0
Also temperatures are in milidegrees. So your 3200 should be 32000.
Temps file starts also from 1 and not 0. (so no temp0...)

Please can you fix this issues? I will do the review later once this things are 
fixed. Values seems to match.

Thanks,
Rudolf
