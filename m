Return-Path: <linux-kernel-owner+w=401wt.eu-S1764946AbYBZUJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764946AbYBZUJc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 15:09:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764637AbYBZUJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 15:09:22 -0500
Received: from antispam.upcomillas.es ([130.206.70.245]:55031 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762611AbYBZUJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 15:09:21 -0500
Subject: Intel 945GM: 2.6.25-rc3 report (with a possible regression)
From: Romano Giannetti <romanol@upcomillas.es>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Date: Tue, 26 Feb 2008 21:09:16 +0100
Message-Id: <1204056556.7745.22.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

this mail is to give feedback about the 2.6.25-rc3 kernel, on an Ubuntu
7.10 system, running on a Toshiba Satellite U305. Video is a Intel
845GM, and I run 915resolution at start to make X happy with the correct
widescreen resolution. 

A lot of data is collected here (if more is needed, tell me):
http://www.dea.icai.upcomillas.es/romano/linux/info/

1) The minor regression is that I cannot have any more a correct
console. I tried a lot of combinations, but without a framebuffer,
console is garbled by ubuntu splash and/or X. With the .config copied in
the site above, I do not have console (a random pattern appears as I
switch consoles). With intelfb framebuffer, sometime it works, sometime
it doesn't work, and everytime break resume from STR. (I mean, the
laptop seems to resume, but the screen is blank).

I have a doubt about this: is it possible that some state is maintained
across reboots? Because sometime two reboots in a row led to different
results; for example, after following 
https://bugs.launchpad.net/ubuntu/+source/initramfs-tools/+bug/147606

I had a nice console, but after the failed resume and a sysrq-b reboot,
no console again. 

2) LCD/CRT switch. It's the first time I tried it, so no idea if it ever
worked. Without a CRT connected, nothing happens pressing the key
combination (fn-F5), correctly. When I connected a overhead proyector
(CRT), pressed fn-F5, and the LCD went off and the CRT on (ok); after
that the LCD never came on again. pressing again fn-f5 two times lead to
a all-off, a third time made the CRT switch on, and again. The laptop is
working but the LCD stay black till the next reboot. (It is very similar
to what seems to happen after resume).

3) on the nice side of things, it seems that now echo mem
> /sys/power/state works (at least in X, I do not have a console to test
it...).

Thank you very much, 
		Romano 

-- 
Sorry for the disclaimer --- ¡I cannot stop it!



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
