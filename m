Return-Path: <linux-kernel-owner+w=401wt.eu-S1757595AbXJ2KLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595AbXJ2KLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 06:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752231AbXJ2KLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 06:11:08 -0400
Received: from ic0245.upco.es ([130.206.70.245]:44407 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbXJ2KLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 06:11:06 -0400
Subject: 2.6.24-rc1: OOPS at  acpi_battery_update
From: Romano Giannetti <romanol@upcomillas.es>
To: linux-kernel@vger.kernel.org
Cc: linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Date: Mon, 29 Oct 2007 11:11:04 +0100
Message-Id: <1193652664.22149.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

	sometime on resuming from s2ram my laptop spew the following oops.
Config, dmesg etc are at: 

http://www.dea.icai.upcomillas.es/romano/linux/info/2624rc1_6/

[    3.475386] Oops: 0000 [#1] SMP 
[    3.475602] Process kacpi_notify (pid: 50, ti=c2122000 task=c210c030 task.ti=c2122000)
[    3.475608] Stack: c35c5060 c02f2a58 00000046 00000000 6b6b6b6b c2b20298 c2123efc c02f29ac 
[    3.475626]        c02166cb f896f3ca 00000000 f896ff63 00000246 00000000 c2b20298 ffffa512 
[    3.475644]        c2123f04 c02f2a58 c2123f34 f896f3ed c2123f1c c34fbdb8 c2123f20 c02f3e22 
[    3.475662] Call Trace:
[    3.475667]  [show_trace_log_lvl+26/48] show_trace_log_lvl+0x1a/0x30
[    3.475678]  [show_stack_log_lvl+177/224] show_stack_log_lvl+0xb1/0xe0
[    3.475695]  [die+282/560] die+0x11a/0x230
[    3.475687]  [show_registers+193/464] show_registers+0xc1/0x1d0
[    3.475703]  [do_page_fault+415/1648] do_page_fault+0x19f/0x670
[    3.475713]  [error_code+114/120] error_code+0x72/0x78
[    3.475722]  [__mutex_unlock_slowpath+172/336] __mutex_unlock_slowpath+0xac/0x150
[    3.475731]  [mutex_unlock+8/16] mutex_unlock+0x8/0x10
[    3.475739]  [<f896f3ed>] acpi_battery_update+0x1ce/0x23c [battery]
[    3.475753]  [<f896f927>] acpi_battery_notify+0x21/0x78 [battery]
[    3.475764]  [acpi_ev_notify_dispatch+79/90] acpi_ev_notify_dispatch+0x4f/0x5a
[    3.475792]  [worker_thread+157/256] worker_thread+0x9d/0x100
[    3.475774]  [acpi_os_execute_notify+36/47] acpi_os_execute_notify+0x24/0x2f
[    3.475784]  [run_workqueue+288/464] run_workqueue+0x120/0x1d0
[    3.475809]  [kernel_thread_helper+7/16] kernel_thread_helper+0x7/0x10
[    3.475801]  [kthread+66/112] kthread+0x42/0x70
[    3.475821] Code: 8d b4 26 00 00 00 00 55 89 e5 83 ec 18 89 5d f8 89 c3 89 75 fc 0f b6 40 04 89 d6 84 c0 7f 24 8d 43 20 3b 43 20 0f 84 e4 00 00 00 <3b> 76 10 0f 85 93 00 00 00 3b 36 90 74 47 8b 5d f8 8b 75 fc 89 
[    3.475818]  =======================
[    3.475909] EIP: [debug_mutex_wake_waiter+36/352] debug_mutex_wake_waiter+0x24/0x160 SS:ESP 0068:c2123ebc




-- 
Sorry for the disclaimer --- ¡I cannot stop it!



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
