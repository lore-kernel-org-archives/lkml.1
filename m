Return-Path: <linux-kernel-owner+w=401wt.eu-S1760128AbZJJMe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760128AbZJJMe6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 08:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758929AbZJJMe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 08:34:58 -0400
Received: from mailout01.t-online.de ([194.25.134.80]:44764 "EHLO
	mailout01.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758661AbZJJMe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 08:34:57 -0400
Message-ID: <4AD07F15.1060501@t-online.de>
Date: Sat, 10 Oct 2009 14:33:25 +0200
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090923 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Logitech Trackman FX detected as "Mouse"?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: TJ+pQYZTrhdwmCoJTJn311IDGvTr01l-6y978VGh6VjwH5M-02-4f7FHvDaWP31ZQr
X-TOI-MSGID: d759a18f-94f0-4897-b4c9-77ba7fe667a1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

I just stumbled over this in logps2pp.c: My Logitech Trackman FX is
detected as "Mouse" instead of "Trackman". dmesg shows

	input: PS2++ Logitech Mouse as /devices/platform/i8042/serio1/input/input4

Surely not a big deal, but I wonder whether this could be related to
the Trackman's wheel emulation not working?

Here is some more information I could find in /sys/devices:

	% cat /sys/devices/platform/i8042/serio1/input/input4/uevent
	PRODUCT=11/2/2/49
	NAME="PS2++ Logitech Mouse"
	PHYS="isa0060/serio1/input0"
	EV==7
	KEY==f0000 0 0 0 0 0 0 0 0
	REL==3
	MODALIAS=input:b0011v0002p0002e0049-e0,1,2,k110,111,112,113,r0,1,amlsfw


It would be very nice if this could be solved. I would be glad to help.


Regards

Harri
