Return-Path: <linux-kernel-owner+w=401wt.eu-S1754555AbYHGPKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbYHGPKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 11:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbYHGPKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 11:10:40 -0400
Received: from ic0245.upco.es ([130.206.70.245]:34187 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbYHGPKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 11:10:39 -0400
Message-ID: <489B1066.1020909@upcomillas.es>
Date: Thu, 07 Aug 2008 17:10:30 +0200
From: Romano Giannetti <romanol@upcomillas.es>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>, drzeus-mmc@drzeus.cx,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: SD cards stopped working on my machine
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I just posted a regression bug on bugzilla:

	http://bugzilla.kernel.org/show_bug.cgi?id=11267

the new kernel stopped to notice the fact that I introduce an SD card into the 
slot of the machine. It used to work perfectly in 2.6.26 (came back and tested, 
so it's not hardware).

In 2.6.26 I had on the dmesg:

[  131.145237] mmc0: new high speed SD card at address b368
[  131.145295] PM: Adding info for mmc:mmc0:b368
[  131.176370] mmcblk0: mmc0:b368 SD    2009600KiB (ro)
[  131.176370] PM: Adding info for No Bus:mmcblk0
[  131.176370]  mmcblk0: p1
[  131.176434] PM: Adding info for No Bus:mmcblk0p1
[  131.176434] PM: Adding info for No Bus:179:0

In 2.6.27-rc2 nothing happens. I have not a lot of time in my hands, so if it's 
possible at all I'd like to avoid a bisect (It's more than one hour per compile 
here...)

Thanks,
	Romano

PD this time at least it didn't eat my photos :-)))))





-- 
Sorry for the disclaimer --- ¡I cannot stop it!


--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
