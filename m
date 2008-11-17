Return-Path: <linux-kernel-owner+w=401wt.eu-S1753891AbYKQQlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbYKQQlB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 11:41:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbYKQQkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 11:40:52 -0500
Received: from antispam.upcomillas.es ([130.206.70.245]:38314 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbYKQQkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 11:40:52 -0500
Message-ID: <49219E8F.70207@upcomillas.es>
Date: Mon, 17 Nov 2008 17:40:47 +0100
From: "Romano Giannetti (lists)" <romanol@upcomillas.es>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Bernhard Schmidt <berni@birkenwald.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Johan Bilien <jobi@via.ecp.fr>,
       Romano Giannetti <romano.giannetti@gmail.com>
Subject: Re: [Bug #11947] 2.6.28-rc VC switching with Intel graphics broken
References: <VwdsQNEjR_C.A.CiD.9_FIJB@chimera> <Q7OAnAv0V3D.A.8gF.CBGIJB@chimera>
In-Reply-To: <Q7OAnAv0V3D.A.8gF.CBGIJB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Rafael J. Wysocki wrote:

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11947
> Subject		: 2.6.28-rc VC switching with Intel graphics broken

Continue to malfunction. More details on the bugzilla entry. But basically, I had:

- one complete lock on VC switching (not switching back, just pressing ctrl-alt-f1).
- 3 two-plus minutes delay on VC switching
- a complete freeze on resuming from ram (not even SysRq-b working).

OTOH, it seems that VC malfunctioning happens only with "visual effect" aka 
compiz on.

Back to 2.6.27.5. This is quite worrying now... should I try to start a
bisection? Although I know from experience that bisecting over a -rc1 is quite
painful.

Romano


-- 
Sorry for the disclaimer --- ¡I cannot stop it!


--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
