Return-Path: <linux-kernel-owner+w=401wt.eu-S1759217AbYBRK4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759217AbYBRK4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 05:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756667AbYBRK4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 05:56:13 -0500
Received: from antispam.upcomillas.es ([130.206.70.245]:45802 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055AbYBRK4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 05:56:12 -0500
Subject: 2.6.25-rc1/2 regression: first-time login into gnome fails
From: Romano Giannetti <romanol@upcomillas.es>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-15
Date: Mon, 18 Feb 2008 11:56:01 +0100
Message-Id: <1203332161.26696.11.camel@pern>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

	I have a very strange, but fully reproducible, regression with
2.6.25-rc1 -rc2. I have an ubuntu 7.10 fully updated.

	The first time after boot, when I login to gnome (through gdm) 
the login half-fails with a Setting Daemon error: failed to connect to
socket /tmp/dbus-<some random stuff>: connection refused. Nothing in the
logs, and there is no such socket in /tmp. 

If I log out and then log in again, all works ok. 

With 2.6.24.2 there is no such a problem.

.config, dmesg (2M buffer size) and syslog here: 

http://www.dea.icai.upcomillas.es/romano/linux/info/


	Romano 


(Back to 2.6.24.2, because ndiswrapper broke again, and ath5k doesn't
like (yet) my atheros adapter...) 

	
-- 
Sorry for the disclaimer --- ¡I cannot stop it!



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
