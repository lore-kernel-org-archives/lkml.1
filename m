Return-Path: <linux-kernel-owner+w=401wt.eu-S1760188AbXKHJz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760188AbXKHJz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 04:55:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758464AbXKHJzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 04:55:48 -0500
Received: from ic0245.upco.es ([130.206.70.245]:45924 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758465AbXKHJzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 04:55:46 -0500
Subject: 2.6.24-rc2 (esthetic?) regression: auto select interrupt spams my
	logs
From: Romano Giannetti <romanol@upcomillas.es>
To: astarikovskiy@suse.de, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Date: Thu, 08 Nov 2007 10:55:44 +0100
Message-Id: <1194515744.7115.12.camel@rukbat>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

After the ACPI changes between 2.6.24-rc1 and -rc2 I have my logs
"spammed" (every 2-3 seconds) by: 

[  423.112903] ACPI: EC: missing IBF_1 confirmations,switch off interrupt mode.
[  423.113020] ACPI: EC: non-query interrupt received, switching to interrupt mode
[  426.078972] ACPI: EC: missing IBF_1 confirmations,switch off interrupt mode.
[  426.079645] ACPI: EC: non-query interrupt received, switching to interrupt mode
[  426.622773] ACPI: EC: missing IBF_1 confirmations,switch off interrupt mode.
[  426.622889] ACPI: EC: non-query interrupt received, switching to interrupt mode

It seems that no harm is done, apart (but it could be another thing)
that gnome-panel is much slower on startup. 

Romano  


-- 
Sorry for the disclaimer --- ¡I cannot stop it!



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
