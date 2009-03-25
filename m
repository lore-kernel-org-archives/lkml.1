Return-Path: <linux-kernel-owner+w=401wt.eu-S1763122AbZCYQVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763122AbZCYQVN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 12:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754947AbZCYQU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 12:20:57 -0400
Received: from mail.gmx.net ([213.165.64.20]:49959 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754732AbZCYQU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 12:20:56 -0400
X-Authenticated: #2025681
X-Provags-ID: V01U2FsdGVkX1/qYatqyOLq0Q/fO8Cm6MXudOX0OE9hmd9WPEiuLw
	7cnzJTekfg0vEJ
Message-ID: <49CA59E8.7080201@gmx.de>
Date: Wed, 25 Mar 2009 17:20:56 +0100
From: Stefan Sassenberg <stefan.sassenberg@gmx.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: /proc/bus/input/devices changing while booting
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.71
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

while booting, an init-script on my machine greps the Handlers entry of 
a certain device (USB touchscreen) from /proc/bus/input/devices. It ends 
with "event2", so I configure my software to listen for events in 
/dev/input/event2. A few seconds later /proc/bus/input/devices changes, 
the order of the devices is different and the Handlers entry for my 
device ends with event1 making my device misconfigured and thus unusable.

Can anybody explain that behaviour? How can I get the final eventX 
device file?

I'm using kernel 2.6.28.8 on an Intel Celeron, chipset ICH5.

Regards

Stefan
