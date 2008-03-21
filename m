Return-Path: <linux-kernel-owner+w=401wt.eu-S1758965AbYCUSu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758965AbYCUSu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 14:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754408AbYCUSuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 14:50:17 -0400
Received: from ic0245.upco.es ([130.206.70.245]:45010 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143AbYCUSuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 14:50:16 -0400
Subject: 2.6.25-rc regression: volume wheel does not work in 2.6.25-rc6
From: Romano Giannetti <romanol@upcomillas.es>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Date: Fri, 21 Mar 2008 19:48:35 +0100
Message-Id: <1206125315.8688.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I have opened a bug in bugzilla for this one: 
http://bugzilla.kernel.org/show_bug.cgi?id=10300

Latest working kernel version:2.6.24.2
Earliest failing kernel version:unknown
Distribution:ubuntu 7.10
Hardware Environment:toshiba laptop U305, sound hda-intel, realtek 268 codec
Software Environment:
Problem Description:

Volume wheel events in 2.6.24 started to be handled by ACPI directly (no events
to the S.O., I have a toshiba OSD appers when using it). Now it seems that
there is no agreement between alsa and the ACPI control. Moving the wheel
changes PCM volume (not master), sometime the two channels (left-right),
sometime just one channel, sometime none, and each time in a seemingly random
way.


Steps to reproduce: move the volume wheel. I marked this low priority because I
use it very rarely (and if I only could map it to the mouse events 5 an 6 it
would be much more useful than to control the volume).

acpidump, alsa info, etc are available 
at http://www.dea.icai.upcomillas.es/romano/linux/info/


-- 
Sorry for the disclaimer --- ¡I cannot stop it!



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
