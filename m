Return-Path: <linux-kernel-owner+w=401wt.eu-S1756292AbYFJMif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292AbYFJMif (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 08:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbYFJMi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 08:38:26 -0400
Received: from ic0245.upco.es ([130.206.70.245]:51856 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbYFJMi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 08:38:26 -0400
Subject: [regression?] Sometime (often) X come out blank (black screen) on
	cold boot - Intel chipset
From: Romano Giannetti <romanol@upcomillas.es>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 10 Jun 2008 14:38:21 +0200
Message-Id: <1213101501.21041.9.camel@pern>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I just opened this: http://bugzilla.kernel.org/show_bug.cgi?id=10892 . I
think itś a regression, but (read the description) I am not so sure, so
I checked regression but I have not blocked Rafael's metabug. 

Latest working kernel version: 2.6.25
Earliest failing kernel version: After 2.6.25, exatcly don't know, probably
2.6.26-rc3
Distribution:Ubuntu 8.04 Hardy
Hardware Environment: toshiba U305 intel-based laptop, see
http://bugzilla.kernel.org/attachment.cgi?id=16067&action=view
Software Environment:xserver-xorg-video-intel  2:2.2.1-1ubuntu12, see also
http://bugzilla.kernel.org/attachment.cgi?id=16066&action=view
Problem Description:

Sometime, on cold boot (after the laptop has been shut off), when the screen
switch from the Ubuntu startup to gdm, the screen goes blank. Forever.
Rebooting (warm) with the same kernel cures it, sometime. If I reboot 2.6.25 it
cures it everytime. 

Otherwise, the system seems to be working.

It was difficult to see because I almost never do a cold boot, the laptop is
either sleeping (s2ram) or on, or (warm) rebooted when I test a new kernel. 

Helps / tricks to gather more data when it happens are welcome.

-- 
Sorry for the disclaimer --- ¡I cannot stop it!



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
