Return-Path: <linux-kernel-owner+w=401wt.eu-S1758677AbXFMQIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758677AbXFMQIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 12:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758168AbXFMQIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 12:08:46 -0400
Received: from smtp-01b.mandic.com.br ([200.225.81.136]:49131 "EHLO
	smtp-01.mandic.com.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752012AbXFMQIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 12:08:46 -0400
Message-ID: <46701685.1090304@mandic.com.br>
Date: Wed, 13 Jun 2007 13:08:37 -0300
From: "Renato S. Yamane" <renatoyamane@mandic.com.br>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [Processor] Hi-Temperature showed in trip points
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I have a laptop Toshiba M45-S355 (with Intel Pentium M Processor 750 - 
1.86GHz) and trip points show me hi-temperature (that is unsupported by 
this processor):

$ uname -a
Linux mandachuva 2.6.21.1 #1 PREEMPT Sun May 20 22:28:53 BRT 2007 i686 
GNU/Linux

$ cat /proc/acpi/thermal_zone/TZCL/trip_points
critical (S5):           105 C

MAX temperature suported by this processor is 100°C (I see this in Intel 
specifications), so I think that is not very good idea allow 
temperatures higher than 100°C.

$ cat /proc/acpi/processor/CPU0/info
processor id:            0
acpi id:                 0
bus mastering control:   yes
power management:        yes
throttling control:      yes
limit interface:         yes

Best regards,
Renato S. Yamane
